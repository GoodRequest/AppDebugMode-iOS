//
//  SessionManager.swift
//
//
//  Created by Matus Klasovity on 21/05/2024.
//

import Combine
import MultipeerConnectivity
import Factory
import SwiftUI

@MainActor
final class DebugManSessionManager: ObservableObject {

    // MARK: - Factory

    @Injected(\.proxySettingsProvider) private var proxyProvider: ProxySettingsProvider
    @Injected(\.sessionDelegateWrapper) private var sessionDelegateWrapper: PeerSessionDelegateWrapper
    @LazyInjected(\.nearbyServicesBrowserDelegate) private var nearbyServicesDelegateWrapper: PeerBrowserDelegateWrapper

    // MARK: - State

    var isSessionDisconnected = false

    private var errorStreamContinuation: AsyncStream<any Error>.Continuation?

    func errorStream() -> AsyncStream<any Error> {
        return AsyncStream { continuation in
            self.errorStreamContinuation = continuation
        }
    }

    // MARK: - Cache

    @AppStorage("remotePeer", store: UserDefaults(suiteName: Constants.suiteName))
    var remotePeer: Peer?

    @AppStorage("localPeer", store: UserDefaults(suiteName: Constants.suiteName))
    var localPeer: Peer = .defaultPeer

    @Published var debugManConnectionState: DebugManConnectionState = .clean {
        didSet {
            print("📊 State changed to \(debugManConnectionState.rawValue)")
        }
    }

    @Published var mitmProxyState: ProxyConfigurationState = .clean

    @AppStorage("proxyIpAddress", store: UserDefaults(suiteName: "AppDebugMode"))
    public var proxyIpAddress: String = ""

    @AppStorage("proxyPort", store: UserDefaults(suiteName: "AppDebugMode"))
    public var proxyPort: Int = 8080

    // MARK: - Properties

    let userDefaultsSuite = UserDefaults(suiteName: Constants.suiteName)

    lazy var session: MCSession = {
        // Session is needed every time since messages are sent for logging there

        let session = MCSession(
            peer: localPeer.asPeerId(),
            securityIdentity: nil,
            encryptionPreference: .none
        )

        return session
    }()

    lazy var browser: MCNearbyServiceBrowser = {
        let browser = MCNearbyServiceBrowser(
            peer: localPeer.asPeerId(),
            serviceType: "Debugman"
        )

        return browser
    }()

    var peers: Set<Peer> = []

    var error: (any Error)? = nil {
        didSet {
            if let error {
                errorStreamContinuation?.yield(error)
            }
        }
    }

    // MARK: - Initializer

    nonisolated
    init() {}

    func start() async {

        if localPeer == .defaultPeer {
            let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "AppDebugMode"
            let newDisplayName = "\(appName) (\(Int.random(in: 10000...99999)))"
            print("👀 Creating new local peer \(newDisplayName)")
            localPeer = Peer(peerId: MCPeerID(displayName: newDisplayName))
        }

        if !proxyIpAddress.isEmpty {
            mitmProxyState = .configured(configuration: ProxyConfiguration(ipAddresses: [proxyIpAddress], port: UInt16(proxyPort)))
        }

        session.delegate = sessionDelegateWrapper

        startListeningToSessionStateUpdates()
        startListeningToPacketUpdates()

        // If remote peer is not nil we are already have an peer to connect to
        if let remotePeer {
            self.debugManConnectionState = .disconnected(from: remotePeer)
            do {
                try await reconnectRemotePeer()
            } catch {
                self.error = error
            }
        } else {
            // If state is clean we will likely need services brower to look for devices
            self.debugManConnectionState = .clean
        }
    }

    func startListeningToSessionStateUpdates() {
        Task {
            for await update in sessionDelegateWrapper.sessionStateStream() {
                handleState(mcSessionState: update.state, peer: update.peer)
            }
        }
    }

    func startListeningToPacketUpdates() {
        Task {
            do {
                for try await packet in sessionDelegateWrapper.peerMessagesStream() {
                    await handleIncomingData(packet: packet)
                }
            } catch {
                errorStreamContinuation?.yield(error)
            }
        }
    }

}

// MARK: Public

extension DebugManSessionManager {

    func send(_ message: String) throws(PeerSessionError) {
        guard let connectedPeer = remotePeer?.asPeerId() else {
            throw .sendingLogsFailed
        }

        let data = Data(message.utf8)

        print("💬 Sending message: \(message)")

        do {
            try session.send(
                data,
                toPeers: [connectedPeer],
                with: .reliable
            )
        } catch {
            print("🔥 Error sending data to peers: \(error)")
            errorStreamContinuation?.yield(error)
        }
    }

    func cleanConfig() {
        Task {
            await proxyProvider.clean()
        }
        mitmProxyState = .clean
        print("📜 Config Cleaned")
    }

    func cleanState() {
        remotePeer = nil
        setState(.clean)
        browser.stopBrowsingForPeers()
        session.disconnect()
        Task {
            await proxyProvider.clean()
        }
        mitmProxyState = .clean
        print("📜 Tabula Rasa")
    }

    func startBrowsing() throws(PeerSessionError) {
        guard debugManConnectionState == .clean else {
            throw .browsingBlocked
        }
        if browser.delegate == nil {
            browser.delegate = nearbyServicesDelegateWrapper
        } else {
            print("delegate already in place")
        }
        browser.delegate = nearbyServicesDelegateWrapper

        print("👀 Starting to browse for peers on the network ...")
        setState(.browsing)
        browser.startBrowsingForPeers()
    }


    func invite(peer: Peer, timeout: TimeInterval) throws(PeerSessionError) {
        guard debugManConnectionState == .browsing else {
            throw .invitingBlocked
        }

        print("💌 Inviting peer: \(peer.asPeerId().displayName)")
        setState(.waitingForAccept(from: peer))

        browser.invitePeer(
            peer.asPeerId(),
            to: session,
            withContext: nil,
            timeout: TimeInterval(timeout)
        )
    }

    func stopBrowsing() throws(PeerSessionError) {
        guard debugManConnectionState == .browsing else {
            throw .stopBrowsingBlocked
        }

        browser.stopBrowsingForPeers()
    }

    func disconnect() throws(PeerSessionError) {
        guard debugManConnectionState.isConnected else {
            throw .disconnectBlocked
        }
        session.disconnect()
        isSessionDisconnected = true
    }

    func unpair() throws(PeerSessionError) {
        print(remotePeer)
        guard remotePeer != nil else {
            throw .unpairBlocked
        }

        self.remotePeer = nil
        setState(.clean)
    }

    func reconnectRemotePeer() async throws(PeerSessionError) {
        guard debugManConnectionState.isDisconnected else {
            throw .reconnectingBlocked
        }


        guard let remotePeer else {
            throw .reconnectingBlocked
        }

        if isSessionDisconnected {
            let session = MCSession(
                peer: localPeer.asPeerId(),
                securityIdentity: nil,
                encryptionPreference: .none
            )
            self.session = session
            session.delegate = sessionDelegateWrapper
            startListeningToSessionStateUpdates()
            isSessionDisconnected = false
        }

        if browser.delegate == nil {
            browser.delegate = nearbyServicesDelegateWrapper
        } else {
            print("delegate already in place")
        }

        browser.startBrowsingForPeers()

        guard let onlineRemotePeer = try? await waitForPeer(
            with: remotePeer,
            timeout: 10,
            wrapper: nearbyServicesDelegateWrapper
        ) else {
            throw .reconnectingPeerNotFound
        }

        browser.invitePeer(
            onlineRemotePeer.asPeerId(),
            to: session,
            withContext: nil,
            timeout: 10
        )

        browser.stopBrowsingForPeers()
    }

}

// MARK: - MCSessionDelegate

extension DebugManSessionManager {

    func handleState(mcSessionState: PeerConnectionState, peer: Peer) {
        print("🛜 MCSession state \(mcSessionState) to peer: \(peer.name)")
        switch mcSessionState {
        case .notConnected:
            setState(.disconnected(from: peer))

        case .connecting:
            setState(.connecting(to: peer))

        case .connected:
            self.remotePeer = peer
            setState(.connected(to: peer))
        }
    }

}

// MARK: - Helper functions - private

private extension DebugManSessionManager {

    func waitForPeer(with peer: Peer, timeout: TimeInterval, wrapper: PeerBrowserDelegateWrapper) async throws -> Peer {
        async let timeoutTask: () = Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))

        while true {
            if let awaitedPeer = wrapper.peers.first(where: { $0 == peer }) {
                return awaitedPeer
            }

            try? await Task.sleep(nanoseconds: 100_000_000)
            try await timeoutTask
        }

        throw MCError(.timedOut)
    }

    func send(_ packet: JSONPacket) throws(ProxyConfigurationError) {
        guard
            debugManConnectionState.isConnected,
            let remotePeer else
        {
            throw .packetSendBlocked
        }

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(packet)
            print("📦 Sending packet: \(packet)")

            try session.send(
                data,
                toPeers: [remotePeer.asPeerId()],
                with: .reliable
            )
        } catch {
            throw .encodingPacketFailed
        }
    }

    func setState(_ newState: DebugManConnectionState) {
        self.debugManConnectionState = newState
    }

}

// MARK: - Proxy Confguration Handling

extension DebugManSessionManager {

    func handleIncomingData(packet: JSONPacket) async {
        switch packet {
        // Test packet
        case .number(let number):
            break

        case .proxyConfiguration(let proxyConfiguration):
            await handleNewProxyConfiguration(proxyConfiguration)

        case .certificateRequest:
            errorStreamContinuation?.yield(ProxyConfigurationError.requestingCertificateFromAppDebugMode)

        case .requireCertificateTrust, .requestProxyConfiguration:
            break

        case .pairingSuccessful:
            print("🎊 TADA")
        }
    }

    func setProxyState(proxyState: ProxyConfigurationState) {
        self.mitmProxyState = proxyState
    }

    // Attempts to validate new configuration again MITMProxy server to validate certificates with IPAdress and port
    func handleNewProxyConfiguration(_ proxyConfiguration: ProxyConfiguration) async {
        setProxyState(proxyState: .testing(configuration: proxyConfiguration))

        #warning("Add saving first configuration")
        #warning("Add requesting first configuration again")

        let port = proxyConfiguration.port
        var didAnyIpPass = false

        for ipAddress in proxyConfiguration.ipAddresses {
            await proxyProvider.updateProxySettings(ipAddress: ipAddress, port: port)
            switch await proxyProvider.testProxyAt(ipAddress: ipAddress, port: port) {
            case .connectionFailed:
                break
            case .missingCertificate:
                break

            case .success:
                didAnyIpPass = true
                await proxyProvider.updateProxySettings(ipAddress: ipAddress, port: port)
            }
        }

        if !didAnyIpPass {
            setProxyState(proxyState: .waitingForUserToTrustMITMProxy)
            print("Error: No IP addresses passed the test. Require Certificate Trust.")
        }
    }

    func validateSavedProxyConfiguration() async throws(ProxyConfigurationError) {
        await setProxyState(proxyState: .testing(configuration: ProxyConfiguration(ipAddresses: [proxyProvider.proxyIpAddress], port: proxyProvider.proxyPortUInt16)))
        let result = await proxyProvider.testProxyAt(ipAddress: proxyIpAddress, port: UInt16(proxyPort))

        switch result {
        case .success:
            try await proxyConfigurationSuccessful()

        case .missingCertificate:
            try await requireCertificateTrust()

        case .connectionFailed:
            throw .testingCertificateConnectionFailed
        }
    }

    func proxyConfigurationSuccessful() async throws(ProxyConfigurationError) {
        guard debugManConnectionState.isConnected,
              mitmProxyState.isTesting
        else {
            throw .sendingSuccessBlocked
        }
        try send(.pairingSuccessful)
    }

    func requestConfiguration() async throws(ProxyConfigurationError) {
        guard debugManConnectionState.isConnected else {
            throw .requestingProxyConfigurationBlocked
        }

        setProxyState(proxyState: .waitingForUserToInstalCertificate)

        do {
            try send(.requestProxyConfiguration)
        } catch {
            throw error
        }
    }


    func requestNewCertificate() async throws(ProxyConfigurationError) {
        guard debugManConnectionState.isConnected,
              !mitmProxyState.isConfigured else {
            throw .requestingNewCertificateBlocked
        }

        setProxyState(proxyState: .waitingForUserToInstalCertificate)

        do {
            try send(.certificateRequest)
        } catch {
            throw error
        }
    }

    func requireCertificateTrust() async throws(ProxyConfigurationError) {
        guard debugManConnectionState.isConnected else {
            throw .requestingCertificateTrustBlocked
        }

        setProxyState(proxyState: .waitingForUserToTrustMITMProxy)

        do {
            try send(.requireCertificateTrust)
        } catch {
            throw error
        }
    }

    func requestNewConfiguration() async throws(ProxyConfigurationError) {
        guard debugManConnectionState.isConnected else {
            throw .requestingProxyConfigurationBlocked
        }

        do {
            try send(.requestProxyConfiguration)
        } catch {
            throw error
        }
    }


}

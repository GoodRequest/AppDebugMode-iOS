//
//  ConnectionsSettingsView.swift
//
//
//  Created by Matus Klasovity on 21/05/2024.
//

import SwiftUI
import Factory

struct ConnectionsSettingsView: View {

    // MARK: - Factory

    @InjectedObject(\.sessionManager) private var sessionManager: DebugManSessionManager

    // MARK: - State

    @State var error: (any Error)?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack {
                Text(verbatim: "⚒️⚠️ This feature is still in development! ⚒️⚠️")
                    .foregroundStyle(AppDebugColors.textPrimary)
                    .font(.title)

                Button(action: {
                    Task {
                        await sessionManager.start()
                    }
                }, label: {
                    Text(verbatim: "Start session manager")
                })

                statusView

                Divider()

                switch sessionManager.debugManConnectionState {
                case .clean:
                    pairButton
                        .padding(.vertical, 24)

                case .browsing:
                    stopBrowsingButton
                    NearbyServicesView(error: $error)

                case .waitingForAccept(let peer):
                    waitingForReplyView(remotePeer: peer)
                        .padding(.vertical, 24)

                case .connecting(let peer):
                    connectingView(remotePeer: peer)
                        .padding(.vertical, 24)

                case .connected(let peer):
                    connectedView(remotePeer: peer)
                        .padding(.vertical, 24)

                case .disconnected(let peer):
                    disconnectedView(remotePeer: peer)
                        .padding(.vertical, 24)
                }

                Divider()

                switch sessionManager.mitmProxyState {
                case .clean:
                    proxyCleanView
                        .padding(.vertical, 24)

                case .waitingForUserToInstalCertificate:
                    RequestingCertificateView(error: $error)
                    #warning("Handle discating the configuration")

                case .waitingForUserToTrustMITMProxy:
                    RequireCertificateTrustView(error: $error)
                    #warning("Handle discating the configuration")

                case .testing:
                    RequireCertificateTrustView(error: $error)

                case .configured(let configuration):
                    proxyConfiguredView(configuration: configuration)
                        .padding(.vertical, 24)
                }

                Divider()

            }
            .padding()
        }
        .background(AppDebugColors.backgroundPrimary.ignoresSafeArea())
        .navigationTitle("Connections")
        .alert("Error", isPresented: .constant(error != nil), presenting: error) { error in
            Button("OK", role: .cancel) {
                self.error = nil
            }
        } message: { error in
            if let error = error as? PeerSessionError {
                print("Error: \(error.description)")
                return Text(error.description)
            } else if let error = error as? ProxyConfigurationError {
                print("Error: \(error.description)")
                return Text(error.description)
            } else {
                print("Error: \(error.localizedDescription)")
                return Text(error.localizedDescription)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        sessionManager.cleanState()
                    }
                }, label: {
                    Text("❌ Session Cache")
                })
            }
        }
    }

}

// MARK: - Componenets

private extension ConnectionsSettingsView {

    var statusView: some View {
        VStack {
            HStack {
                Text("AppDebugMode Status")
                    .bold()
                    .foregroundStyle(AppDebugColors.textPrimary)

                Spacer()

                Text(sessionManager.debugManConnectionState.title)
                    .foregroundStyle(AppDebugColors.textSecondary)
            }

            HStack {
                Text("Proxy Config Status")
                    .bold()
                    .foregroundStyle(AppDebugColors.textPrimary)

                Spacer()

                Text(sessionManager.mitmProxyState.title)
                    .foregroundStyle(AppDebugColors.textSecondary)
            }

            HStack {
                Text("Local device")
                    .bold()
                    .foregroundStyle(AppDebugColors.textPrimary)

                Spacer()

                Text(sessionManager.localPeer.asPeerId().displayName)
                    .foregroundStyle(AppDebugColors.textSecondary)
            }

            HStack {
                Text("Remote device")
                    .bold()
                    .foregroundStyle(AppDebugColors.textPrimary)

                Spacer()

                Text(sessionManager.remotePeer?.asPeerId().displayName ?? "none")
                    .foregroundStyle(AppDebugColors.textSecondary)
            }
        }
    }

    var pairButton: some View {
        ButtonFilled(text: "Browse for a new device") {
            handleThrowingCall(action: { try sessionManager.startBrowsing() })
        }
    }

    var stopBrowsingButton: some View {
        ButtonFilled(text: "Stop browing for a new device") {
            handleThrowingCall(action: { try sessionManager.stopBrowsing() })
        }
    }

    func connectingView(remotePeer: Peer) -> some View {
        #warning("Handle cancelling connecting state to clean state")
        return ProgressView {
            Text("Connecting to \(remotePeer.asPeerId().displayName)")
        }
        .foregroundStyle(AppDebugColors.textPrimary)
        .tint(AppDebugColors.textPrimary)
    }

    func disconnectedView(remotePeer: Peer) -> some View {
        return Group {
            Text("You are disconnected from \(remotePeer.asPeerId().displayName)")
                .foregroundStyle(AppDebugColors.textPrimary)
            ButtonFilled(text: "Reconnect") {
                handleThrowingCall(action: { try await sessionManager.reconnectRemotePeer() })
            }
            ButtonFilled(text: "Unpair") {
                handleThrowingCall(action: { try sessionManager.unpair() })
            }
        }
    }

    func waitingForReplyView(remotePeer: Peer) -> some View {
        #warning("Handle cancelling waiting state to clean state")
        return Group {
            ProgressView {
                Text("Waiting for remote peer: \(remotePeer.asPeerId().displayName) to accept the invite")
            }
            .foregroundStyle(AppDebugColors.textPrimary)
            .tint(AppDebugColors.textPrimary)
        }
    }

    func connectedView(remotePeer: Peer) -> some View {
        Group {
            Text("😘 Good Job you did it! 🎊 You are connected to \(remotePeer.asPeerId().displayName)")
                .foregroundStyle(AppDebugColors.textPrimary)
            ButtonFilled(text: "Disconnect") {
                handleThrowingCall { try sessionManager.disconnect() }
            }
            ButtonFilled(text: "Unpair") {
                handleThrowingCall { try sessionManager.unpair() }
            }
        }
    }

    var proxyCleanView: some View {
        Group {
            Text("Proxy not configured")
                .foregroundStyle(AppDebugColors.textPrimary)

            ButtonFilled(text: "Request config") {
                handleThrowingCall { try await sessionManager.requestNewCertificate() }
            }
        }
    }

    func proxyConfiguredView(configuration: ProxyConfiguration) -> some View {
        Group {
            Text("😘 Good Job you did it! 🎊 Your proxy is configured with \(configuration.ipAddresses), on port \(configuration.port)")
                .foregroundStyle(AppDebugColors.textPrimary)
            ButtonFilled(text: "Clean Config") {
                handleThrowingCall(action: { try sessionManager.cleanConfig() })
            }
        }
    }

    func handleThrowingCall(action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                await handleError(error)
            }
        }
    }

    func handleError(_ error: Error) async {
        self.error = error
    }

}

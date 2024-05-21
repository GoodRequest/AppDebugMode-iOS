//
//  ConnectionsManager.swift
//  
//
//  Created by Matus Klasovity on 21/05/2024.
//

import Foundation
import MultipeerConnectivity

final class ConnectionsManager: NSObject, ObservableObject {

    let session: MCSession
    let browser: MCNearbyServiceBrowser

    @Published var connectedPeers: [MCPeerID] = []

    override init() {
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let peer = MCPeerID(
            displayName: UIDevice.current.name + " - " + (appName ?? "")
        )

        browser = MCNearbyServiceBrowser(
            peer: peer,
            serviceType: "LogDog"
        )
        session = MCSession(
            peer: peer,
            securityIdentity: nil,
            encryptionPreference: .none
        )
        super.init()

        session.delegate = self
    }

    func cancelConnection(to peer: MCPeerID) {
        session.cancelConnectPeer(peer)
    }

    func sendToAllPeers(message: String) {
        guard !session.connectedPeers.isEmpty else { return }

        let data = Data(message.utf8)
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("error sending data to peers: \(error)")
        }
    }

}


extension ConnectionsManager: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("not connected to peer: \(peerID.displayName)")

        case .connecting:
            print("connecting to peer: \(peerID.displayName)")

        case .connected:
            print("connected to peer: \(peerID.displayName)")

        @unknown default:
            print("unknown state: \(state)")
        }

        DispatchQueue.main.async { [weak self] in
            self?.connectedPeers = session.connectedPeers
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("received data from peer: \(peerID)")
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("received stream from peer: \(peerID)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("started receiving resource from peer: \(peerID)")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        print("finished receiving resource from peer: \(peerID)")
    }

}

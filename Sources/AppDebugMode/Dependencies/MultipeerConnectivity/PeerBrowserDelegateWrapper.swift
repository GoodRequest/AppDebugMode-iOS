//
//  PeerBrowserDelegateWrapper.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 27/09/2024.
//

import MultipeerConnectivity

final class PeerBrowserDelegateWrapper: NSObject {

    var peers: Set<Peer> = []

    // MARK: - Streams

    private var peerDiscoveryStreamContinuation: AsyncThrowingStream<Set<Peer>, Error>.Continuation?

    public func peerDiscoveryStream() -> AsyncThrowingStream<Set<Peer>, Error> {
        return AsyncThrowingStream { continuation in
            self.peerDiscoveryStreamContinuation = continuation
        }
    }

    func stopPeerDiscoveryStream() {
        peerDiscoveryStreamContinuation?.finish()
    }

}

extension PeerBrowserDelegateWrapper: MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: any Error) {
        print("❌ [MCNearbyServiceBrowserDelegate] didNotStartBrowsingForPeers \(error.localizedDescription)")
        peerDiscoveryStreamContinuation?.yield(with: .failure(error))
        stopPeerDiscoveryStream()
        browser.stopBrowsingForPeers()
    }

    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String: String]?
    ) {
        if info?["pairing"] == "YES" {
            print("🛜 [MCNearbyServiceBrowserDelegate] foundPeer for pairing \(peerID.displayName)")
            peers.insert(Peer(peerId: peerID))
            peerDiscoveryStreamContinuation?.yield(with: .success(peers))
        } else {
            print("🛜 [MCNearbyServiceBrowserDelegate] foundPeer \(peerID.displayName)")
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.remove(Peer(peerId: peerID))
        peerDiscoveryStreamContinuation?.yield(with: .success(peers))
        peerDiscoveryStreamContinuation?.yield(peers)
        print("🛜 [MCNearbyServiceBrowserDelegate] lostPeer \(peerID.displayName)")
    }

}

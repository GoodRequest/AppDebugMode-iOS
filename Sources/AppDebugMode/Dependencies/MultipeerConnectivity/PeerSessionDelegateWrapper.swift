//
//  PeerSessionDelegateWrapper.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 27/09/2024.
//

import MultipeerConnectivity
import SwiftUI

// MARK: - MCSessionDelegate

final class PeerSessionDelegateWrapper: NSObject {

    // MARK: - Initializer

    override init() {}

    // MARK: - Streams

    private var sessionStateStreamContinuation: AsyncStream<(peer: Peer, state: PeerConnectionState)>.Continuation?

    func sessionStateStream() -> AsyncStream<(peer: Peer, state: PeerConnectionState)> {
        return AsyncStream { continuation in
            self.sessionStateStreamContinuation = continuation
        }
    }

    private var peerMessagesStreamContinuation: AsyncThrowingStream<JSONPacket, Error>.Continuation?

    func peerMessagesStream() -> AsyncThrowingStream<JSONPacket, Error> {
        return AsyncThrowingStream { continuation in
            self.peerMessagesStreamContinuation = continuation
        }
    }

    func stopSessionStateStream() {
        sessionStateStreamContinuation?.finish()
    }

    func stopPeerMessageStream() {
        peerMessagesStreamContinuation?.finish()
    }

}

// MARK: - Delegate

extension PeerSessionDelegateWrapper: MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        sessionStateStreamContinuation?.yield((peer: Peer(peerId: peerID), state: PeerConnectionState(mcSessionState: state)))
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("⬇️ received data from peer: \(peerID) data: \(String(describing: String(data: data, encoding: .utf8)))")
        do {
            let decoder = JSONDecoder()
            let jsonPacket = try decoder.decode(JSONPacket.self, from: data)
            peerMessagesStreamContinuation?.yield(with: .success(jsonPacket))
        } catch let error {
            peerMessagesStreamContinuation?.yield(with: .failure(error))
        }
    }

    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {}

    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {}

    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {}

}

//
//  PeerConnectionState.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 27/09/2024.
//

import MultipeerConnectivity

enum PeerConnectionState: String, Equatable, RawRepresentable {

    case notConnected
    case connected
    case connecting

    // MARK: - Initializer

    init(mcSessionState: MCSessionState) {
        switch mcSessionState {
        case .connected:
            self = .connected
        case .connecting:
            self = .connecting
        case .notConnected:
            self = .notConnected
        @unknown default:
            self = .notConnected
        }
    }

}

extension PeerConnectionState: Identifiable {

    var id: String { self.rawValue }

}

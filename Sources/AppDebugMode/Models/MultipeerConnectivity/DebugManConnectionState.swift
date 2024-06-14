//
//  DebugManConnectionState.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 04/10/2024.
//

import Foundation
import Foundation

import Foundation

enum DebugManConnectionState: RawRepresentable, Sendable, Codable {

    case clean
    case browsing
    case waitingForAccept(from: Peer)
    case connecting(to: Peer)
    case connected(to: Peer)
    case disconnected(from: Peer)

    typealias RawValue = String

    // Raw value conversion
    var rawValue: String {
        switch self {
        case .clean:
            return "clean"
        case .browsing:
            return "browsing"
        case .waitingForAccept(let peer):
            return "waitingForAccept:\(peer.rawValue)"
        case .connecting(let peer):
            return "connecting:\(peer.rawValue)"
        case .connected(let peer):
            return "connected:\(peer.rawValue)"
        case .disconnected(let peer):
            return "disconnected:\(peer.rawValue)"
        }
    }

    // Initialize from raw value
    init?(rawValue: String) {
        let components = rawValue.split(separator: ":").map { String($0) }
        guard let firstComponent = components.first else { return nil }

        switch firstComponent {
        case "clean":
            self = .clean
        case "browsing":
            self = .browsing
        case "waitingForAccept":
            guard let peerRawValue = components.dropFirst().first,
                  let peer = Peer(rawValue: peerRawValue) else { return nil }
            self = .waitingForAccept(from: peer)
        case "connecting":
            guard let peerRawValue = components.dropFirst().first,
                  let peer = Peer(rawValue: peerRawValue) else { return nil }
            self = .connecting(to: peer)
        case "connected":
            guard let peerRawValue = components.dropFirst().first,
                  let peer = Peer(rawValue: peerRawValue) else { return nil }
            self = .connected(to: peer)
        case "disconnected":
            guard let peerRawValue = components.dropFirst().first,
                  let peer = Peer(rawValue: peerRawValue) else { return nil }
            self = .disconnected(from: peer)
        default:
            return nil
        }
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case type
        case peer
    }

    // Encode the enum into a JSON-compatible format
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .clean:
            try container.encode("clean", forKey: .type)
        case .browsing:
            try container.encode("browsing", forKey: .type)
        case .waitingForAccept(let peer):
            try container.encode("waitingForAccept", forKey: .type)
            try container.encode(peer, forKey: .peer)
        case .connecting(let peer):
            try container.encode("connecting", forKey: .type)
            try container.encode(peer, forKey: .peer)
        case .connected(let peer):
            try container.encode("connected", forKey: .type)
            try container.encode(peer, forKey: .peer)
        case .disconnected(let peer):
            try container.encode("disconnected", forKey: .type)
            try container.encode(peer, forKey: .peer)
        }
    }

    // Decode the enum from a JSON-compatible format
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        do {
            switch type {
            case "clean":
                self = .clean
            case "browsing":
                self = .browsing
            case "waitingForAccept":
                let peer = try container.decode(Peer.self, forKey: .peer)
                self = .waitingForAccept(from: peer)
            case "connecting":
                let peer = try container.decode(Peer.self, forKey: .peer)
                self = .connecting(to: peer)
            case "connected":
                let peer = try container.decode(Peer.self, forKey: .peer)
                self = .connected(to: peer)
            case "disconnected":
                let peer = try container.decode(Peer.self, forKey: .peer)
                self = .disconnected(from: peer)
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown DebugManConnectionState type")
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

extension DebugManConnectionState {

    var title: String {
        switch self {
        case .clean:
            return "clean"
        case .browsing:
            return "browsing"
        case .waitingForAccept:
            return "waitingForAccept"
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        }
    }

    var isWaitingForAccept: Bool {
        switch self {
        case .waitingForAccept: return true
        default: return false
        }
    }

    var connecting: Bool {
        switch self {
        case .connecting: return true
        default: return false
        }
    }

    var isConnected: Bool {
        switch self {
        case .connected: return true
        default: return false
        }
    }

    var isDisconnected: Bool {
        switch self {
        case .disconnected: return true
        default: return false
        }
    }

}

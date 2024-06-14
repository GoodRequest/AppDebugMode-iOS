
import Foundation
import MultipeerConnectivity

struct Peer: RawRepresentable, Identifiable, Hashable, Equatable, Codable, @unchecked Sendable {

    typealias RawValue = String

    static let defaultPeer = Peer(peerId: .init(displayName: "Default"))

    let name: String
    let peerId: MCPeerID

    var id: String { name }

    init(peerId: MCPeerID) {
        self.name = peerId.displayName
        self.peerId = peerId
    }

    func asPeerId() -> MCPeerID {
        peerId
    }

    // MARK: - RawRepresentable
    init?(rawValue: RawValue) {
        guard let data = rawValue.data(using: .utf8),
              let peer = try? JSONDecoder().decode(Peer.self, from: data) else {
            return nil
        }
        self = peer
    }

    var rawValue: RawValue {
        guard let data = try? JSONEncoder().encode(self),
              let jsonString = String(data: data, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }

    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case name
        case peerId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

        let peerIdData = try container.decode(Data.self, forKey: .peerId)
        guard let unarchivedPeerId = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MCPeerID.self, from: peerIdData) else {
            throw DecodingError.dataCorruptedError(forKey: .peerId, in: container, debugDescription: "Unable to decode MCPeerID")
        }
        peerId = unarchivedPeerId
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)

        let archivedData = try NSKeyedArchiver.archivedData(withRootObject: peerId, requiringSecureCoding: true)
        try container.encode(archivedData, forKey: .peerId)
    }

    // MARK: - Hashable & Equatable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: Peer, rhs: Peer) -> Bool {
        lhs.id == rhs.id
    }

}

extension Peer: Comparable { public static func < (lhs: Peer, rhs: Peer) -> Bool { lhs.id < rhs.id } }

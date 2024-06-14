//
//  SessionState.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 27/09/2024.
//

enum DebugmanSessionState: Equatable, Sendable, RawRepresentable, Codable {

    case error(description: String)
    case notPaired
    case pairingBonjour
    case requestingCertificate
    case requireCertificateTrust
    case pairedDisconnected
    case pairedConnecting
    case pairedConnected

    // RawRepresentable conformance using String
    init?(rawValue: String) {
        if rawValue.hasPrefix("error:") {
            let errorMessage = String(rawValue.dropFirst("error:".count))
            self = .error(description: errorMessage)
        } else {
            switch rawValue {
            case "notPaired":
                self = .notPaired
            case "pairingBonjour":
                self = .pairingBonjour
            case "requestingCertificate":
                self = .requestingCertificate
            case "requireCertificateTrust":
                self = .requireCertificateTrust
            case "pairedDisconnected":
                self = .pairedDisconnected
            case "pairedConnecting":
                self = .pairedConnecting
            case "pairedConnected":
                self = .pairedConnected
            default:
                return nil
            }
        }
    }

    var rawValue: String {
        switch self {
        case .error(let description):
            return "error:\(description)"
        case .notPaired:
            return "notPaired"
        case .pairingBonjour:
            return "pairingBonjour"
        case .requestingCertificate:
            return "requestingCertificate"
        case .requireCertificateTrust:
            return "requireCertificateTrust"
        case .pairedDisconnected:
            return "pairedDisconnected"
        case .pairedConnecting:
            return "pairedConnecting"
        case .pairedConnected:
            return "pairedConnected"
        }
    }

    // Codable conformance to handle encoding/decoding
    enum CodingKeys: String, CodingKey {
        case type
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "error":
            let description = try container.decode(String.self, forKey: .description)
            self = .error(description: description)
        case "notPaired":
            self = .notPaired
        case "pairingBonjour":
            self = .pairingBonjour
        case "requestingCertificate":
            self = .requestingCertificate
        case "requireCertificateTrust":
            self = .requireCertificateTrust
        case "pairedDisconnected":
            self = .pairedDisconnected
        case "pairedConnecting":
            self = .pairedConnecting
        case "pairedConnected":
            self = .pairedConnected
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown session state")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .error(let description):
            try container.encode("error", forKey: .type)
            try container.encode(description, forKey: .description)
        case .notPaired:
            try container.encode("notPaired", forKey: .type)
        case .pairingBonjour:
            try container.encode("pairingBonjour", forKey: .type)
        case .requestingCertificate:
            try container.encode("requestingCertificate", forKey: .type)
        case .requireCertificateTrust:
            try container.encode("requireCertificateTrust", forKey: .type)
        case .pairedDisconnected:
            try container.encode("pairedDisconnected", forKey: .type)
        case .pairedConnecting:
            try container.encode("pairedConnecting", forKey: .type)
        case .pairedConnected:
            try container.encode("pairedConnected", forKey: .type)
        }
    }

    var description: String {
        switch self {
        case .notPaired:
            return "No device paired"
        case .pairingBonjour:
            return "Pairing"
        case .requestingCertificate:
            return "Configuring proxy"
        case .requireCertificateTrust:
            return "Configuring certificate"
        case .error(_):
            return "Error"
        case .pairedDisconnected:
            return "Disconnected"
        case .pairedConnecting:
            return "Connecting"
        case .pairedConnected:
            return "Connected"
        }
    }
}

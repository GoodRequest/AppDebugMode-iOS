//
//  JSONPacket.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 12/06/2024.
//

import Foundation

enum JSONPacket: Codable, Equatable, Sendable, RawRepresentable {

    case proxyConfiguration(ProxyConfiguration)
    case certificateRequest
    case requireCertificateTrust
    case pairingSuccessful
    case requestProxyConfiguration
    case logMessage(String) // New case for exchanging logs

    init?(rawValue: String) {
        let decoder = JSONDecoder()

        if let data = rawValue.data(using: .utf8) {
            if let packet = try? decoder.decode(JSONPacket.self, from: data) {
                self = packet
                return
            }
        }
        return nil
    }

    var rawValue: String {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "{}"
    }

    enum CodingKeys: String, CodingKey {
        case proxyConfiguration
        case certificateRequest
        case requireCertificateTrust
        case pairingSuccessful
        case requestProxyConfiguration
        case logMessage // New key for log message
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .proxyConfiguration(let config):
            try container.encode(config, forKey: .proxyConfiguration)
        case .certificateRequest:
            try container.encode(true, forKey: .certificateRequest)
        case .requireCertificateTrust:
            try container.encode(true, forKey: .requireCertificateTrust)
        case .pairingSuccessful:
            try container.encode(true, forKey: .pairingSuccessful)
        case .requestProxyConfiguration:
            try container.encode(true, forKey: .requestProxyConfiguration)
        case .logMessage(let message): // Encoding log message
            try container.encode(message, forKey: .logMessage)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let config = try? container.decode(ProxyConfiguration.self, forKey: .proxyConfiguration) {
            self = .proxyConfiguration(config)
        } else if (try? container.decode(Bool.self, forKey: .certificateRequest)) != nil {
            self = .certificateRequest
        } else if (try? container.decode(Bool.self, forKey: .requireCertificateTrust)) != nil {
            self = .requireCertificateTrust
        } else if (try? container.decode(Bool.self, forKey: .pairingSuccessful)) != nil {
            self = .pairingSuccessful
        } else if (try? container.decode(Bool.self, forKey: .requestProxyConfiguration)) != nil {
            self = .requestProxyConfiguration
        } else if let message = try? container.decode(String.self, forKey: .logMessage) { // Decoding log message
            self = .logMessage(message)
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .requestProxyConfiguration,
                in: container, debugDescription: "Invalid JSONPacket case"
            )
        }
    }
}

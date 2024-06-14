//
//  JSONPacket.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 12/06/2024.
//

import Foundation

enum JSONPacket: Codable, Equatable, Sendable, RawRepresentable {

    case number(Int)
    case proxyConfiguration(ProxyConfiguration)
    case certificateRequest
    case requireCertificateTrust
    case pairingSuccessful
    case requestProxyConfiguration

    // Define RawRepresentable conformance with String raw values
    init?(rawValue: String) {
        let decoder = JSONDecoder()

        // Attempt to decode from a JSON string
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
        return "{}" // Return empty JSON object as fallback
    }

    // Custom CodingKeys to handle Codable conformance
    enum CodingKeys: String, CodingKey {
        case number
        case proxyConfiguration
        case certificateRequest
        case requireCertificateTrust
        case pairingSuccessful
        case requestProxyConfiguration
    }

    // Implement Codable conformance to encode/decode cases with associated values
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .number(let value):
            try container.encode(value, forKey: .number)
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
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let value = try? container.decode(Int.self, forKey: .number) {
            self = .number(value)
            return
        }

        if let config = try? container.decode(ProxyConfiguration.self, forKey: .proxyConfiguration) {
            self = .proxyConfiguration(config)
            return
        }

        if (try? container.decode(Bool.self, forKey: .certificateRequest)) != nil {
            self = .certificateRequest
            return
        }

        if (try? container.decode(Bool.self, forKey: .requireCertificateTrust)) != nil {
            self = .requireCertificateTrust
            return
        }

        if (try? container.decode(Bool.self, forKey: .pairingSuccessful)) != nil {
            self = .pairingSuccessful
            return
        }

        if (try? container.decode(Bool.self, forKey: .requestProxyConfiguration)) != nil {
            self = .requestProxyConfiguration
            return
        }

        throw DecodingError.dataCorruptedError(forKey: .number, in: container, debugDescription: "Invalid JSONPacket case")
    }
}

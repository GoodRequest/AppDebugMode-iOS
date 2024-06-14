//
//  ProxyConfigurationState.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 04/10/2024.
//

import Foundation

enum ProxyConfigurationState: RawRepresentable, Sendable, Codable {
    case clean
    case waitingForUserToInstalCertificate
    case waitingForUserToTrustMITMProxy
    case testing(configuration: ProxyConfiguration)
    case configured(configuration: ProxyConfiguration)

    typealias RawValue = String

    // Convert the enum to its `RawValue` representation
    var rawValue: String {
        switch self {
        case .clean:
            return "clean"
        case .waitingForUserToTrustMITMProxy:
            return "waitingForPermission"
        case .waitingForUserToInstalCertificate:
            return "waitingForInstall"
        case .testing(let configuration):
            return "testing:\(configurationToString(configuration))"
        case .configured(let configuration):
            return "configured:\(configurationToString(configuration))"
        }
    }

    var title: String {
        switch self {
        case .clean:
            return "clean"
        case .waitingForUserToTrustMITMProxy:
            return "waitingForPermission"
        case .waitingForUserToInstalCertificate:
            return "waitingForInstall"
        case .testing:
            return "testing"
        case .configured:
            return "configured"
        }
    }

    // Initialize the enum from its `RawValue`
    init?(rawValue: String) {
        let components = rawValue.split(separator: ":").map { String($0) }
        guard let firstComponent = components.first else {
            return nil
        }

        switch firstComponent {
        case "clean":
            self = .clean
        case "waitingForPermission":
            self = .waitingForUserToTrustMITMProxy
        case "waitingForInstall":
            self = .waitingForUserToInstalCertificate
        case "testing":
            guard let configRawValue = components.dropFirst().first,
                  let configuration = Self.stringToConfiguration(configRawValue) else {
                return nil
            }
            self = .testing(configuration: configuration)
        case "configured":
            guard let configRawValue = components.dropFirst().first,
                  let configuration = Self.stringToConfiguration(configRawValue) else {
                return nil
            }
            self = .configured(configuration: configuration)
        default:
            return nil
        }
    }

    // MARK: - Helpers for encoding/decoding ProxyConfiguration to/from String

    private func configurationToString(_ configuration: ProxyConfiguration) -> String {
        guard let data = try? JSONEncoder().encode(configuration),
              let jsonString = String(data: data, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }

    static private func stringToConfiguration(_ rawValue: String) -> ProxyConfiguration? {
        guard let data = rawValue.data(using: .utf8),
              let configuration = try? JSONDecoder().decode(ProxyConfiguration.self, from: data) else {
            return nil
        }
        return configuration
    }

    // MARK: - Codable Conformance

    enum CodingKeys: String, CodingKey {
        case type
        case configuration
    }

    // Encode the enum into a JSON-compatible format
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .clean:
            try container.encode("clean", forKey: .type)
        case .waitingForUserToTrustMITMProxy:
            try container.encode("waitingForPermission", forKey: .type)
        case .waitingForUserToInstalCertificate:
            try container.encode("waitingForInstall", forKey: .type)
        case .testing(let configuration):
            try container.encode("testing", forKey: .type)
            try container.encode(configuration, forKey: .configuration)
        case .configured(let configuration):
            try container.encode("configured", forKey: .type)
            try container.encode(configuration, forKey: .configuration)
        }
    }

    // Decode the enum from a JSON-compatible format
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "clean":
            self = .clean
        case "waitingForPermission":
            self = .waitingForUserToTrustMITMProxy
        case "waitingForInstall":
            self = .waitingForUserToInstalCertificate
        case "testing":
            let configuration = try container.decode(ProxyConfiguration.self, forKey: .configuration)
            self = .testing(configuration: configuration)
        case "configured":
            let configuration = try container.decode(ProxyConfiguration.self, forKey: .configuration)
            self = .configured(configuration: configuration)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown MITMProxyState type")
        }
    }

    var isTesting: Bool {
        switch self {
        case .testing: return true
        default: return false
        }
    }

    var isConfigured: Bool {
        switch self {
        case .configured: return true
        default: return false
        }
    }

}

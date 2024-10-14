//
//  UserProfile.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Foundation

public struct UserProfile: Codable, Equatable, Sendable, RawRepresentable {

    // MARK: - Properties

    public let name: String
    public let password: String

    // MARK: - RawRepresentable conformance

    // The raw value will be a JSON string representing the UserProfile
    public var rawValue: String {
        // Convert the UserProfile to a JSON-encoded string
        guard let data = try? JSONEncoder().encode(self) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }

    // Initializer from rawValue (JSON string)
    public init?(rawValue: String) {
        // Convert the JSON string back into a UserProfile
        guard let data = rawValue.data(using: .utf8),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else { return nil }
        self = profile
    }

    // Initializer for UserProfile
    public init(name: String, password: String) {
        self.name = name
        self.password = password
    }

}

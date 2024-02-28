//
//  LargeObjectResponse.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Andrej Jasso on 28/02/2024.
//

import Foundation

struct LargeObjectResponse: Codable {

    let ctRoot: [CTRoot]
    
}

// MARK: - CTRoot
struct CTRoot: Codable {
    let id, name, dob: String
    let address: Address
    let telephone: String
    let pets: [String]
    let score: Double
    let email: String
    let url: String
    let description: String
    let verified: Bool
    let salary: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, dob, address, telephone, pets, score, email, url, description, verified, salary
    }
}

// MARK: - Address
struct Address: Codable {
    let street, town, postode: String
}

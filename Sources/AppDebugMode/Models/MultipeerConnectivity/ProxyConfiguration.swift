//
//  ProxyConfiguration.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 12/06/2024.
//

struct ProxyConfiguration: Codable, Equatable, Sendable {

    let ipAddresses: [String]
    let port: UInt16

}

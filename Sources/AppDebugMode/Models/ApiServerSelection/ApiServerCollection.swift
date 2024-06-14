//
//  ApiServerCollection.swift
//  
//  Created by Matus Klasovity on 02/07/2023.
//

import Foundation

public struct ApiServerCollection: Sendable, Hashable {

    let name: String
    let servers: [ApiServer]
    let defaultServer: ApiServer

    public init(name: String, servers: [ApiServer], defaultServer: ApiServer) {
        self.name = name
        self.servers = servers
        self.defaultServer = defaultServer
    }

}

//
//  ApiServer.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Foundation

public struct ApiServer: Codable, Equatable, Hashable {
    
    public let name: String
    public let url: String
    
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
}

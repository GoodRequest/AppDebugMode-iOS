//
//  File.swift
//  
//
//  Created by Matus Klasovity on 23/08/2023.
//

import Foundation

final class PushNotificationsProvider {
    
    var token: String?
    let deleteToken: () async throws -> Void
    let getToken: () async throws -> String
    
    init(token: String?, deleteToken: @escaping () async throws -> Void, getToken: @escaping () async throws -> String) {
        self.token = token
        self.deleteToken = deleteToken
        self.getToken = getToken
    }
    
}

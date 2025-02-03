//
//  File.swift
//  
//
//  Created by Matus Klasovity on 23/08/2023.
//

import Foundation

public final class PushNotificationsProvider: Sendable {

    let token: String?
    let deleteToken: @Sendable () async throws -> Void
    let getToken: @Sendable () async throws -> String

    init<T: AppDebugFirebaseMessaging>(firebaseMessaging: T) {
        self.token = firebaseMessaging.fmcToken
        self.deleteToken = firebaseMessaging.deleteToken
        self.getToken = firebaseMessaging.token
    }

}

//
//  PushNotificationsProvider.swift
//  AppDebugMode-iOS
//
//  Created by Matus Klasovity on 23/08/2023.
//

import Foundation

public final class PushNotificationsProvider {

    var token: String?
    let deleteToken: () async throws -> Void
    let getToken: () async throws -> String

    init?(firebaseMessaging: AnyObject) {
        let type: AnyObject.Type = type(of: firebaseMessaging)
        class_addProtocol(type, AppDebugFirebaseMessaging.self)

        if let appDebugFirebaseMesaging = firebaseMessaging as? AppDebugFirebaseMessaging {
            self.token = appDebugFirebaseMesaging.fmcToken
            self.deleteToken = appDebugFirebaseMesaging.deleteToken
            self.getToken = appDebugFirebaseMesaging.token
        }
        return nil
    }

}

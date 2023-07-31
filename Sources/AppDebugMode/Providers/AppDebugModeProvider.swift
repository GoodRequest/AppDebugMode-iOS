//
//  AppDebugModeProvider.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Foundation
import Combine

public final class AppDebugModeProvider {
    
    // MARK: - Shared
    
    public static let shared = AppDebugModeProvider()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Properties
    
    var servers: [ApiServer] = []
    var serversCollections: [ApiServerCollection] = []
    var onServerChange: (() -> Void)?
    var pushNotificationsProvider: PushNotificationsProvider? /// (any AppDebugFirebaseMessaging)?
    
    // MARK: - Methods
    
    public var selectedTestingUser: TestingUser? {
        TestingUsersProvider.shared.selectedTestingUser
    }
    
    public var selectedTestingUserPublisher = TestingUsersProvider.shared.selectedTestingUserPublisher
    
    public func setup(
        serversCollections: [ApiServerCollection],
        onServerChange: (() -> Void)? = nil,
        cacheManager: Any? = nil,
        firebaseMessaging: AnyObject? = nil
    ) {
        self.serversCollections = serversCollections
        self.onServerChange = onServerChange
        
        if let cacheManager {
            CacheProvider.shared.setup(cacheManager: cacheManager)
        }

        if let firebaseMessaging {
            setupFirebaseMessaging(firebaseMessaging: firebaseMessaging)
        }
    }
    
    public func getSelectedServer(for serverCollection: ApiServerCollection) -> ApiServer {
        serversCollections.first { $0 == serverCollection }!.selectedServer
    }
    
}

// MARK: - Private

private extension AppDebugModeProvider {
    
    func setupFirebaseMessaging(firebaseMessaging: AnyObject) {
        let type = type(of: firebaseMessaging)
        class_addProtocol(type, AppDebugFirebaseMessaging.self)
        
        if let appDebugFirebaseMesaging = firebaseMessaging as? AppDebugFirebaseMessaging {
            pushNotificationsProvider = PushNotificationsProvider(
                token: appDebugFirebaseMesaging.fmcToken,
                deleteToken: appDebugFirebaseMesaging.deleteToken,
                getToken: appDebugFirebaseMesaging.token
            )
        }
    }

}

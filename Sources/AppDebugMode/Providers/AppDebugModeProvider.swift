//
//  AppDebugModeProvider.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Combine
import SwiftUI

public final class AppDebugModeProvider {
    
    // MARK: - Shared
    
    public static let shared = AppDebugModeProvider()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Properties
    
    var servers: [ApiServer] = []
    var serversCollections: [ApiServerCollection] = []
    var onServerChange: (() -> Void)?
    var pushNotificationsProvider: PushNotificationsProvider?
    
    // MARK: - Methods
    
    @available(*, deprecated, renamed: "selectedUserProfile")
    public var selectedTestingUser: UserProfile? {
        UserProfilesProvider.shared.selectedUserProfile
    }
    
    public var selectedUserProfile: UserProfile? {
        UserProfilesProvider.shared.selectedUserProfile
    }
    
    @available(*, deprecated, renamed: "selectedUserProfilePublisher")
    public var selectedTestingUserPublisher = UserProfilesProvider.shared.selectedUserProfilePublisher
    public var selectedUserProfilePublisher = UserProfilesProvider.shared.selectedUserProfilePublisher
    
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

    public func start() -> UIViewController {
        let view = AppDebugView(serversCollections: AppDebugModeProvider.shared.serversCollections)
        let hostingViewController = UIHostingController(rootView: view)

        return hostingViewController
    }
    
}

// MARK: - Private

private extension AppDebugModeProvider {
    
    func setupFirebaseMessaging(firebaseMessaging: AnyObject) {
        let type: AnyObject.Type = type(of: firebaseMessaging)
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

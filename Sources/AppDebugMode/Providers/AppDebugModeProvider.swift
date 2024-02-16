//
//  AppDebugModeProvider.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Combine
import SwiftUI

public final class AppDebugModeProvider {
    
    // MARK: - Singleton

    public static let shared = AppDebugModeProvider()
    
    // MARK: - Initialization

    private init() {}
    
    // MARK: - Internal - Variables

    internal var servers: [ApiServer] = []
    internal var serversCollections: [ApiServerCollection] = []
    internal var onServerChange: (() -> Void)?
    internal var pushNotificationsProvider: PushNotificationsProvider?

    // MARK: - Public - Variables

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

    public var shouldRedirectLogsToAppDebugMode: Bool {
        StandardOutputService.shared.shouldRedirectLogsToAppDebugMode
    }

}

// MARK: - Public - Helper functions

public extension AppDebugModeProvider {

    func setup(
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

        if StandardOutputService.shared.shouldRedirectLogsToAppDebugMode {
            StandardOutputService.shared.redirectLogsToAppDebugMode()
        }
    }

    func getSelectedServer(for serverCollection: ApiServerCollection) -> ApiServer {
        serversCollections.first { $0 == serverCollection }!.selectedServer
    }

    func start() -> UIViewController {
        let view = AppDebugView(serversCollections: AppDebugModeProvider.shared.serversCollections)
        let hostingViewController = UIHostingController(rootView: view)

        return hostingViewController
    }

}

// MARK: - Private - Helper functions

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

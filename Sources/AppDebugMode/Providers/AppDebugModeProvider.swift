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

    internal let connectionManager = ConnectionsManager()
    internal var servers: [ApiServer] = []
    internal var serversCollections: [ApiServerCollection] = []
    internal var onServerChange: (() -> Void)?
    internal var pushNotificationsProvider: PushNotificationsProvider?
    internal var customControls: any View = EmptyView()
    internal var customControlsViewIsVisible: Bool {
        !(customControls is EmptyView)
    }

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

    /// Setup the AppDebugModeProvider with the given parameters.
    /// - Parameters:
    ///  - serversCollections: The collections of servers to be displayed in the app debug mode.
    ///  - onServerChange: The closure to be called when the server is changed.
    ///  - cacheManager: The cache manager to be used in the app debug mode.
    ///  - firebaseMessaging: The Firebase Messaging to be used in the app debug mode.
    ///  - customControls: The custom controls to be displayed in the app debug mode.
    func setup(
        serversCollections: [ApiServerCollection] = [],
        onServerChange: (() -> Void)? = nil,
        cacheManager: Any? = nil,
        firebaseMessaging: AnyObject? = nil,
        @ViewBuilder customControls: () -> some View = { EmptyView() }
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
        self.customControls = customControls()
    }

    func getSelectedServer(for serverCollection: ApiServerCollection) -> ApiServer {
        serversCollections.first { $0 == serverCollection }!.selectedServer
    }

    func start() -> UIViewController {
        let viewController = AppDebugView(
            serversCollections: AppDebugModeProvider.shared.serversCollections,
            customControls: AnyView( AppDebugModeProvider.shared.customControls),
            customControlsViewIsVisible: AppDebugModeProvider.shared.customControlsViewIsVisible
        )
        .environmentObject(connectionManager)
        .eraseToUIViewController()

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.configureSolidAppearance()
        return navigationController
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

//
//  AppDebugModeProvider.swift
//
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Combine
import SwiftUI
import Factory
import PulseProxy
import Pulse
import GoodNetworking

public struct ApiServerPickerConfiguration {

    public init(
        serversCollections: ApiServerCollection,
        onSelectedServerChange: CheckedContinuation<ApiServer, Never>? = nil
    ) {
        self.serversCollections = serversCollections
        #warning("TODO: Leaking continuation fix")
        self.onSelectedServerChange = onSelectedServerChange
    }

    var serversCollections: ApiServerCollection
    var onSelectedServerChange: CheckedContinuation<ApiServer, Never>?

}

public actor PackageManager {

    init() {}

    public static let shared = PackageManager()

    // MARK: - Injected

    @Injected(\.sessionManager) private var sessionManager: DebugManSessionManager
    @Injected(\.outputProcessor) private var outputProcessor: StandardOutputProcessor
    @Injected(\.profileProvider) private var profileProvider: UserProfilesProvider
    @Injected(\.proxySettingsProvider) private var proxyProvider: ProxySettingsProvider

    // MARK: - Internal - Variables

    internal var customControls: any View = EmptyView()
    internal var customControlsViewIsVisible: Bool {
        !(customControls is EmptyView)
    }
    internal var pulseLoggingEnabled: Bool = true

    // MARK: - State

    @AppStorage("shouldRedirectLogsToAppDebugMode", store: UserDefaults(suiteName: Constants.suiteName))
    var shouldRedirectLogsToAppDebugMode = !DebuggerService.debuggerConnected()

    // MARK: - Variable

    private var userProfileProvider = UserProfilesProvider()

    // MARK: - Public - Variables

    public var selectedUserProfile: UserProfile? {
        userProfileProvider.selectedUserProfile
    }

}

// MARK: - Public - Helper functions

public extension PackageManager {

    /// Setup the AppDebugModeProvider with the given parameters.
    /// - Parameters:
    ///  - serversCollections: The collections of servers to be displayed in the app debug mode.
    ///  - onServerChange: The closure to be called when the server is changed.
    ///  - cacheManager: The cache manager to be used in the app debug mode.
    ///  - firebaseMessaging: The Firebase Messaging to be used in the app debug mode.
    ///  - customControls: The custom controls to be displayed in the app debug mode.
    ///  
    func setup(
        serverProviders: [DebugSelectableServerProvider],
        configurableProxySessionProvider: ConfigurableSessionProvider?,
        firebaseMessaging: AnyObject? = nil,
        customControls: (some View)? = nil,
        pulseLoggingEnabled: Bool = true
    ) async {
        self.pulseLoggingEnabled = pulseLoggingEnabled
        if pulseLoggingEnabled {
            NetworkLogger.enableProxy()
        }

        if !serverProviders.isEmpty {
            Container.shared.setupServerProviders(providers: serverProviders)
        }

        if let configurableProxySessionProvider {
            Container.shared.setupConfigurableProxySessionProvider(provider: configurableProxySessionProvider)
            Task {
                await proxyProvider.updateProxySettings(ipAddress: proxyProvider.proxyIpAddress, port: proxyProvider.proxyPortUInt16)
            }
        }

        if let firebaseMessaging {
            Container.shared.setupAPNSProvider(firebaseMessaging: firebaseMessaging as! AppDebugFirebaseMessaging)
        }

        if shouldRedirectLogsToAppDebugMode {
            await outputProcessor.redirectLogsToAppDebugMode()
        }

        self.customControls = customControls
    }

    @MainActor
    func start() async -> UIViewController {
        let viewController = await AppDebugView(
            customControls: AnyView(customControls),
            customControlsViewIsVisible: customControlsViewIsVisible,
            pulseLoggingEnabled: pulseLoggingEnabled
        )
        .eraseToUIViewController()

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.configureSolidAppearance()
        return navigationController
    }

}

//
//  DependencyContainer.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 18/09/2024.
//

import Factory
import GoodNetworking

public extension Container {

    var packageManager: Factory<PackageManager> {
        Factory(self) { PackageManager.shared }.singleton
    }

    var outputProcessor: Factory<StandardOutputProcessor> {
        Factory(self) { StandardOutputProcessor.shared }.singleton
    }

    var profileProvider: Factory<UserProfilesProvider> {
        Factory(self) { UserProfilesProvider() }.singleton
    }


    var apnsProviding: Factory<PushNotificationsProvider?> {
        Factory(self) { nil }
    }

    func setupAPNSProvider(firebaseMessaging: AnyObject) {
        if let provider = PushNotificationsProvider(firebaseMessaging: firebaseMessaging) {
            Container.shared.apnsProviding.register { provider }
        }
    }

    var debugServerSelectors: Factory<[DebugSelectableServerProvider]> {
        Factory(self) { [] }.singleton
    }

    func setupServerProviders(providers: [DebugSelectableServerProvider]) {
        Container.shared.debugServerSelectors.register {
            providers
        }
    }

    var configurableProxySessionProvider: Factory<ConfigurableSessionProvider?> {
        Factory(self) { nil }.singleton
    }

    func setupConfigurableProxySessionProvider(provider: ConfigurableSessionProvider) {
        Container.shared.configurableProxySessionProvider.register {
            provider
        }
    }


}

// MARK: - MC Session for DebugMan

extension Container {

    var nearbyServicesBrowserDelegate: Factory<PeerBrowserDelegateWrapper> {
        Factory(self) { PeerBrowserDelegateWrapper() }.singleton
    }

    var sessionDelegateWrapper: Factory<PeerSessionDelegateWrapper> {
        Factory(self) { PeerSessionDelegateWrapper() }.singleton
    }

    var sessionManager: Factory<DebugManSessionManager> {
        Factory(self) {
            let sessionManager = DebugManSessionManager()
            Task {
                await sessionManager.start()
            }
            return sessionManager
        }.singleton
    }

    var proxySettingsProvider: Factory<ProxySettingsProvider> {
        Factory(self) { ProxySettingsProvider() }.singleton
    }

}

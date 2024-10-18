//
//  Container.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Andrej Jaššo on 20/09/2024.
//

import Factory
import GoodNetworking

#if DEBUG
import AppDebugMode
import Alamofire
import GoodLogger
#endif

extension Container {

    var requestManager: Factory<RequestManagerType> {
        Factory(self) {
            RequestManager(baseUrlProvider: self.urlProvider.resolve())
        }.singleton
    }

    var urlProvider: Factory<BaseUrlProviding> {
        Factory(self) {
                self.serverSelector.resolve()
        }.singleton
    }

    #if DEBUG
    var serverSelector: Factory<DebugSelectableServerProvider> {
        Factory(self) {
            DebugSelectableServerProvider(apiServerPickerConfiguration: .init(serversCollections: Constants.devServerCollection))
        }.singleton
    }
    #else
    var serverSelector: Factory<BaseUrlProviding> {
        Factory(self) { Constants.prodServer }.singleton
    }
    #endif

    #if DEBUG
    var configurableSessionProvider: Factory<ConfigurableSessionProvider> {
        LoggingEventMonitor.maxVerboseLogSizeBytes = 1000000 // For testing 400kb large payload
        let monitor = LoggingEventMonitor(logger: AppDebugModeLogger())
        
        let defaultSession = Alamofire.Session(
            configuration: .default,
            eventMonitors: [monitor]
        )

        return Factory(self) { ConfigurableSessionProvider(defaultSession: defaultSession) }.singleton
    }
    #endif

}

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
    var serverSelector: Factory<SampleSelectableBaseUrlProvider> {
        Factory(self) {
            SampleSelectableBaseUrlProvider(serverCollection: Constants.prodServerCollection)
        }.singleton
    }
    #endif

    #if DEBUG
    var configurableSessionProvider: Factory<ConfigurableSessionProvider> {
        LoggingEventMonitor.maxVerboseLogSizeBytes = 1000000
        let monitor = LoggingEventMonitor(logger: AppDebugModeLogger())

        let defaultConfiguration = NetworkSessionConfiguration(
            urlSessionConfiguration: .default,
            eventMonitors: [monitor]
        )
        return Factory(self) { ConfigurableSessionProvider(defaultConfiguration: defaultConfiguration, defaultSession: .default) }.singleton
    }
    #endif

}

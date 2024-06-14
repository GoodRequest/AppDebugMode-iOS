//
//  ConfigurableProvider.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 30/09/2024.
//

@preconcurrency import Alamofire
import GoodNetworking

public actor ConfigurableSessionProvider: NetworkSessionProviding {

    public let defaultConfiguration: NetworkSessionConfiguration
    public var currentConfiguration: NetworkSessionConfiguration
    public var configurationChanged = true
    public var currentSession: Alamofire.Session
    public let defaultSession: Alamofire.Session

    public init(defaultConfiguration: NetworkSessionConfiguration, defaultSession: Alamofire.Session) {
        self.defaultConfiguration = defaultConfiguration
        self.currentConfiguration = defaultConfiguration
        self.defaultSession = defaultSession
        self.currentSession = defaultSession
    }

    public func updateConfiguration(with configuration: NetworkSessionConfiguration) async {
        self.currentConfiguration = configuration
        self.configurationChanged = true
        print("⚙️ Updated ConfigurableSessionProvider to \(configuration)")
    }

    public func resolveSession() async -> Alamofire.Session {
        if configurationChanged {
            print("🛜 Resolved new URLSession with configuration: \(currentConfiguration)")
            configurationChanged = false
            currentSession = Alamofire.Session(
                configuration: currentConfiguration.urlSessionConfiguration,
                interceptor: currentConfiguration.interceptor,
                serverTrustManager: currentConfiguration.serverTrustManager,
                eventMonitors: currentConfiguration.eventMonitors
            )
            return currentSession
        } else {
            print("🛜 Resolved old URLSession with configuration: \(currentConfiguration)")
            return currentSession
        }
    }

}

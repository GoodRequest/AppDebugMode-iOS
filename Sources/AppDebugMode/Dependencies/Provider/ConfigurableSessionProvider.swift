//
//  ConfigurableSessionProvider.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 17/10/2024.
//

@preconcurrency import Alamofire
import GoodNetworking
import GoodLogger
import Foundation

public actor ConfigurableSessionProvider: NetworkSessionProviding {

    public var isSessionValid = false

    public func invalidateSession() async {
        logger.log(level: .debug, message: "Invalidating session not supported", privacy: .auto)
    }

    public func makeSession() async -> Alamofire.Session {
        logger.log(
            level: .debug,
            message: "🛜 Resolved new URLSession with configuration: \(currentConfiguration)",
            privacy: .auto
        )
        isSessionValid = true

        currentSession = Alamofire.Session(
            configuration: currentConfiguration,
            interceptor: currentSession.interceptor,
            serverTrustManager: currentSession.serverTrustManager,
            eventMonitors: [currentSession.eventMonitor]
        )

        return currentSession
    }

    public var currentConfiguration: URLSessionConfiguration
    public var currentSession: Alamofire.Session

    /// A private property that provides the appropriate logger based on the iOS version.
    ///
    /// For iOS 14 and later, it uses `OSLogLogger`. For earlier versions, it defaults to `PrintLogger`.
    private var logger: GoodLogger {
        if #available(iOS 14, *) {
            return OSLogLogger()
        } else {
            return PrintLogger()
        }
    }

    public init(defaultSession: Alamofire.Session = .default) {
        self.currentConfiguration = defaultSession.sessionConfiguration
        self.currentSession = defaultSession
        
    }

    public func updateConfiguration(with urlConfiguration: URLSessionConfiguration) async {
        self.currentConfiguration = urlConfiguration
        self.isSessionValid = false
        logger.log(
            level: .debug,
            message: "⚙️ Updated ConfigurableSessionProvider to \(String(describing: urlConfiguration.connectionProxyDictionary))",
            privacy: .auto
        )
    }

    public func resolveSession() async -> Alamofire.Session {
        logger.log(
            level: .debug,
            message: "🛜 Resolved old URLSession with configuration: \(currentConfiguration)",
            privacy: .auto
        )

        return currentSession
    }

}

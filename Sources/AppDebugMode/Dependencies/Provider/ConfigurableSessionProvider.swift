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
        logger.log(message: "Invalidating session not supported", level: .debug)
    }

    public func makeSession() async -> Alamofire.Session {
        logger.log(
            message: "🛜 Resolved new URLSession with configuration: \(currentConfiguration)",
            level: .debug
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
            message: "⚙️ Updated ConfigurableSessionProvider to \(String(describing: urlConfiguration.connectionProxyDictionary))",
            level: .debug
        )
    }

    public func resolveSession() async -> Alamofire.Session {
        logger.log(
            message: "🛜 Resolved old URLSession with configuration: \(currentConfiguration)",
            level: .debug
        )

        return currentSession
    }

}

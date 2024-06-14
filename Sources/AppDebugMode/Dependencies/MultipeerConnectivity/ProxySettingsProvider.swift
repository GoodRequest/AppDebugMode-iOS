//
//  ProxySettingsProvider.swift
//
//
//  Created by Matus Klasovity on 28/05/2024.
//

import SwiftUI
import Factory
import GoodNetworking

@MainActor
public final class ProxySettingsProvider: Sendable {

    // MARK: - Singleton

    public static let shared = ProxySettingsProvider()

    // MARK: - Properties

    @AppStorage("proxyIpAddress", store: UserDefaults(suiteName: "AppDebugMode"))
    public var proxyIpAddress: String = ""

    @AppStorage("proxyPort", store: UserDefaults(suiteName: "AppDebugMode"))
    public var proxyPort: Int = 8080

    // MARK: - Computed Property

    var proxyPortUInt16: UInt16 {
        get {
            return UInt16(proxyPort)
        }
        set {
            proxyPort = Int(newValue)
        }
    }

    // MARK: - Public

    public func urlSessionConfiguration() -> URLSessionConfiguration {
        urlSessionConfiguration(proxyIpAddress: proxyIpAddress, proxyPort: proxyPortUInt16)
    }
    
    public func urlSessionConfiguration(proxyIpAddress: String, proxyPort: UInt16) -> URLSessionConfiguration {
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.connectionProxyDictionary = [AnyHashable: Any]()
        urlSessionConfig.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
        urlSessionConfig.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = proxyIpAddress
        urlSessionConfig.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = proxyPort
        urlSessionConfig.connectionProxyDictionary?["HTTPSProxy"] = proxyIpAddress
        urlSessionConfig.connectionProxyDictionary?["HTTPSPort"] = proxyPort

        print("Getting configuration, \(urlSessionConfig), \(proxyIpAddress), \(proxyPort)")
        return urlSessionConfig
    }

    func updateProxySettings(ipAddress: String, port: UInt16) {
        proxyIpAddress = ipAddress
        proxyPort = Int(port)
        print("⚙️ Changed ProxySettingsProvider to ipAddress:\(ipAddress) and port:\(port)")
        
        guard let configurableProxySessionProvider = Container.shared.configurableProxySessionProvider.resolve() else { return }

        Task {
            let urlConfig = urlSessionConfiguration(proxyIpAddress: proxyIpAddress, proxyPort: proxyPortUInt16)
            let newConfiguration = await NetworkSessionConfiguration(
                urlSessionConfiguration: urlConfig,
                interceptor: configurableProxySessionProvider.currentConfiguration.interceptor,
                serverTrustManager: configurableProxySessionProvider.currentConfiguration.serverTrustManager,
                eventMonitors: configurableProxySessionProvider.currentConfiguration.eventMonitors
            )
            await configurableProxySessionProvider.updateConfiguration(with: newConfiguration)
        }
    }

    func clean() {
        proxyIpAddress = ""
        proxyPort = 8080
    }
    
    func testProxyAt(ipAddress: String, port: UInt16) async -> ProxyConfigurationTestResult {
        let urlSessionConfiguration = urlSessionConfiguration(proxyIpAddress: ipAddress, proxyPort: port)
        print("🧪 Testing Proxy: \( ipAddress), \(port)")

        let testingSession = URLSession(configuration: urlSessionConfiguration)
        let testingUrl = URL(string: "https://mitm.it")!

        do {
            let _ = try await testingSession.data(from: testingUrl)
            return .success
        } catch let error as NSError where error.code == 310 || error.code == -1200 { // certificate compromised
            return .missingCertificate
        } catch _ {
            return .connectionFailed
        }
    }

}

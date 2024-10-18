//
//  ProxySettingsProvider.swift
//  Debugman
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

    @AppStorage("isProxyValidated", store: UserDefaults(suiteName: "AppDebugMode"))
    public var isProxyValidated = false

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
    
    nonisolated public func urlSessionConfiguration(proxyIpAddress: String, proxyPort: UInt16) -> URLSessionConfiguration {
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.connectionProxyDictionary = [
            "HTTPEnable": true,
            "HTTPProxy": proxyIpAddress,
            "HTTPPort": proxyPort,
            "HTTPSEnable": true,
            "HTTPSProxy": proxyIpAddress,
            "HTTPSPort": proxyPort
        ]

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
            await configurableProxySessionProvider.updateConfiguration(with: urlConfig)
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
            isProxyValidated = true
            print("🧪 Testing Proxy: success")
            return .success
        } catch let error as NSError where error.code == 310 || error.code == -1200 { // certificate compromised
            print("🧪 Testing Proxy: missing certificate")
            return .missingCertificate
        } catch _ {
            print("🧪 Testing Proxy: connection failure")
            return .connectionFailed
        }
    }

}

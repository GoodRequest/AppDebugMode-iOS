//
//  ProxySettingsProvider.swift
//
//
//  Created by Matus Klasovity on 28/05/2024.
//

import Foundation
import GoodPersistence

public final class ProxySettingsProvider {

    @UserDefaultValue("proxyIpAdress", defaultValue: "")
    var proxyIpAdress: String

    @UserDefaultValue("proxyPort", defaultValue: 8080)
    var proxyPort: Int

    public static let shared = ProxySettingsProvider()

    public var urlSessionConfiguration: URLSessionConfiguration {
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.connectionProxyDictionary = [AnyHashable: Any]()
        urlSessionConfig.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
        urlSessionConfig.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = proxyIpAdress
        urlSessionConfig.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = proxyPort
        urlSessionConfig.connectionProxyDictionary?["HTTPSProxy"] = proxyIpAdress
        urlSessionConfig.connectionProxyDictionary?["HTTPSPort"] = proxyPort

        return urlSessionConfig
    }

    func updateProxySettings(ipAddress: String, port: Int) {
        proxyIpAdress = ipAddress
        proxyPort = port

        exit(0)
    }

}

//
//  RequestManager.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Foundation
import Combine
import GoodNetworking
import Alamofire
#if DEBUG
import AppDebugMode
#endif

final class RequestManager: RequestManagerType {
    
    enum ApiServer: String {
        
        case base
        
        var rawValue: String {
            #if DEBUG
            return AppDebugModeProvider.shared.getSelectedServer(for: Constants.ServersCollections.sampleBackend).url
            #else
            return Constants.ProdServer.url
            #endif
        }
        
    }
    
    private let session: NetworkSession

    init(baseServer: ApiServer) {
        LoggingEventMonitor.maxVerboseLogSizeBytes = 1000000
        let monitor = LoggingEventMonitor(logger: nil)
        #if DEBUG
        StandardOutputService.shared.connectCustomLogStreamPublisher(monitor.subscribeToMessages())
        #endif

        #if DEBUG
        let urlSessionConfig = AppDebugModeProvider.shared.proxySettingsProvider.urlSessionConfiguration
        #else
        let urlSessionConfig = URLSessionConfiguration.default
        #endif

        session = NetworkSession(
            baseUrl: baseServer.rawValue,
            configuration: NetworkSessionConfiguration(
                urlSessionConfiguration: urlSessionConfig,
                interceptor: nil,
                eventMonitors: [monitor]
            )
        )
    }

    func fetchLarge() -> AnyPublisher<LargeObjectResponse, AFError> {
        session.request(endpoint: Endpoint.large, base: "https://codepo8.github.io")
            .goodify()
            .eraseToAnyPublisher()
    }

    func fetchCars(id: Int) -> AnyPublisher<CarResponse, AFError> {
        return session.request(endpoint: Endpoint.cars(id))
            .goodify()
            .eraseToAnyPublisher()
    }
    
    func fetchProducts(id: Int) -> AnyPublisher<ProductResponse, AFError> {
        return session.request(endpoint: Endpoint.products(id))
            .goodify()
            .eraseToAnyPublisher()
    }
    
}

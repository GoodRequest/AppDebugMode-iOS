//
//  RequestManager.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Foundation
import GoodNetworking
@preconcurrency import Alamofire
import GoodLogger

#if DEBUG
import AppDebugMode
import Factory
#endif

actor RequestManager: RequestManagerType {

    #if DEBUG
    @Injected(\.configurableSessionProvider) private var sessionProvider: ConfigurableSessionProvider
    #endif

    private var session: NetworkSession

    init(baseUrlProvider: BaseUrlProviding) {

        #if DEBUG
        session = NetworkSession(
            baseUrlProvider: baseUrlProvider,
            networkSessionProvider: Container.shared.configurableSessionProvider.resolve()
        )
        #else
        let monitor = LoggingEventMonitor(logger: OSLogLogger())

        session = NetworkSession(
            baseUrlProvider: baseUrlProvider,
            configuration: NetworkSessionConfiguration(
                urlSessionConfiguration: .default,
                eventMonitors: [monitor]
            )
        )
        #endif
    }

    func fetchLargeObject() async throws -> LargeObjectResponse {
        try await session.request(endpoint: Endpoint.large, base: "https://codepo8.github.io")
    }

    func fetchCars(id: Int) async throws -> CarResponse {
        try await session.request(endpoint: Endpoint.cars(id))
    }

    func fetchProducts(id: Int) async throws -> ProductResponse {
        try await session.request(endpoint: Endpoint.products(id))
    }

}

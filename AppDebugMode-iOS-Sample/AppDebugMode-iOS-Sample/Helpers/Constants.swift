//
//  Constants.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 19/09/2023.
//

import GoodNetworking
#if DEBUG
import AppDebugMode
#endif


struct Constants {
    
    // MARK: - Servers

    #if DEBUG
    static let devServer = AppDebugMode.ApiServer(name: "PRODUCTS", url: "https://fakestoreapi.com/")
    static let prodServer = AppDebugMode.ApiServer(name: "CARS", url: "https://myfakeapi.com/api/")
    static let testServer = AppDebugMode.ApiServer(name: "TEST", url: "https://myfakeapi.com/api/test")

    static let devServerCollection = AppDebugMode.ApiServerCollection(
        name: "Development Servers",
        servers: [devServer, prodServer],
        defaultServer: devServer
    )

    static let testServerCollection = AppDebugMode.ApiServerCollection(
        name: "Test Servers",
        servers: [devServer, prodServer],
        defaultServer: devServer
    )
    #else

    static let prodServer = "https://myfakeapi.com/api/"

    #endif
    
}

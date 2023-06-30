//
//  ApiServerProvider.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import GoodPersistence

struct ApiServerProvider {
    
    // MARK: - Cache
    
    @UserDefaultValue("DebugAPIServer", defaultValue: nil)
    private var cachedApiServer: ApiServer?
    
    // MARK: - Shared
    
    static let shared = ApiServerProvider()
    
    // MARK: - Init
    
    private init() {}

    // MARK: - Properties
    var apiServer: ApiServer {
        guard let cachedApiServer else {
            fatalError("Specify default value with: ApiServerProvider.setDefaultValue")
        }
        
        return cachedApiServer
    }

    // MARK: - Functions
    
    func changeApiServer(server: ApiServer?) {
        cachedApiServer = server
    }
    
    func setDefaultValue(server: ApiServer) {
        if cachedApiServer == nil {
            cachedApiServer = server
        }
    }

}

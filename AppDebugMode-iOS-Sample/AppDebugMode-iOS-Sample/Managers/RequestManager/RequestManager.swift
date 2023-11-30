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

    
    private let session: GRSession<Endpoint, ApiServer>
    
    init(baseServer: ApiServer) {
        session = GRSession(baseURL: baseServer, configuration: .default)
    }
    
    func fetchCars(id: Int) -> AnyPublisher<CarResponse, AFError> {
        return session.request(endpoint: .cars(id))
            .goodify()
            .eraseToAnyPublisher()
    }
    
    func fetchProducts(id: Int) -> AnyPublisher<ProductResponse, AFError> {
        return session.request(endpoint: .products(id))
            .goodify()
            .eraseToAnyPublisher()
    }
    
}

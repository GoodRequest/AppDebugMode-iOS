//
//  Endpoint.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 18/09/2023.
//

import Foundation
import GoodNetworking
import Alamofire

enum Endpoint: GREndpointManager {
    
    case cars(Int)
    case products(Int)
    
    var path: String {
        switch self {
        case .cars(let carId):
            return "cars/\(carId)"
            
        case .products(let productId):
            return "products/\(productId)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var parameters: EndpointParameters? { nil }
    
    var headers: HTTPHeaders? { nil }
    
    var encoding: ParameterEncoding { JSONEncoding.default }
    
    func asURL(baseURL: String) throws -> URL {
        var url = try baseURL.asURL()
        url.appendPathComponent(path)
        return url
    }
    
}

//
//  Endpoint.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 18/09/2023.
//

import Foundation
import GoodNetworking
import Alamofire

enum Endpoint: GoodNetworking.Endpoint {

    case large
    case cars(Int)
    case products(Int)
    
    var path: String {
        switch self {
        case .large:
            return "json-dummy-data/411k.json"
            
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
    
    func url(on baseURL: String) throws -> URL {
        var url = try baseURL.asURL()
        url.appendPathComponent(path)
        return url
    }
    
}

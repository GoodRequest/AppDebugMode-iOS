//
//  RequestManagerType.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Foundation
import Alamofire
import Combine

protocol RequestManagerType: AnyObject {
    
    func fetchCars(id: Int) -> AnyPublisher<CarResponse, AFError>
    func fetchProducts(id: Int) -> AnyPublisher<ProductResponse, AFError>
    
}

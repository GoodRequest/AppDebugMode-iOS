//
//  RequestManagerType.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Foundation
import Alamofire
import Combine

protocol RequestManagerType: Sendable {
    
    func fetchCars(id: Int) async throws -> CarResponse
    func fetchProducts(id: Int) async throws -> ProductResponse
    func fetchLargeObject() async throws -> LargeObjectResponse

}

//
//  CarResponse.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 18/09/2023.
//

import Foundation

struct CarResponse: Codable {
    
    let car: Car
    
    enum CodingKeys: String, CodingKey {
        case car = "Car"
    }
    
}

struct Car: Codable {
    
    let id: Int
    let car: String
    let carModel: String
    
    enum CodingKeys: String, CodingKey {
        case carModel = "car_model"
        case id, car
    }
    
}

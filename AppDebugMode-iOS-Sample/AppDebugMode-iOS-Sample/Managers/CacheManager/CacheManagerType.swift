//
//  CacheManagerType.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import Foundation

protocol CacheManagerType {
    
    var fullName: String? { get set }
    var gender: Int { get set }
    
    // MARK: - Update
    
    func updateFullName(with name: String)
    func udpateGender(with gender: Int)
    
}

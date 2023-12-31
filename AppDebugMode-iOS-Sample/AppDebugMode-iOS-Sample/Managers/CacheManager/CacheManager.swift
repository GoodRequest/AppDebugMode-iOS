//
//  CacheManager.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import GoodPersistence

final class CacheManager: CacheManagerType {
    
    @UserDefaultValue("fullName", defaultValue: nil)
    var fullName: String?
    
    @UserDefaultValue("gender", defaultValue: 0)
    var gender: Int
    
    // MARK: - Update
    
    func updateFullName(with name: String) {
        self.fullName = name
    }
    
    func udpateGender(with gender: Int) {
        self.gender = gender
    }
    
}

//
//  SettingsViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import Foundation

final class ProfileViewModel {
    
    // MARK: - TypeAliases
    
    typealias DI = WithCacheManager
    
    // MARK: - Constants
    
    private let di: DI
    private let coordinator: Coordinator<AppStep>
    
    // MARK: - Variables
    
    var fullName = String()
    var gender = Int()
    
    // MARK: - Initializer
    
    init(di: DI, coordinator: Coordinator<AppStep>) {
        self.coordinator = coordinator
        self.di = di
        
        fullName = loadFullName() ?? ""
    }
    
}

// MARK: - Public

extension ProfileViewModel {
    
    func saveUserData() {
        di.cacheManager.updateFullName(with: fullName)
        di.cacheManager.udpateGender(with: gender)
    }
    
    func loadFullName() -> String? {
        return di.cacheManager.fullName
    }
    
    func loadGender() -> Int {
        return di.cacheManager.gender
    }
    
}

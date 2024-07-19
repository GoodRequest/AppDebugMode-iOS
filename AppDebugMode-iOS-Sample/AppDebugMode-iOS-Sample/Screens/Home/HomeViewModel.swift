//
//  HomeViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import Foundation
import UIKit

final class HomeViewModel {

    // MARK: - Constants
    
    private let coordinator: Coordinator<AppStep>
    
    // MARK: - Initializer
    
    init(coordinator: Coordinator<AppStep>) {
        self.coordinator = coordinator
    }
    
}

// MARK: - Public

extension HomeViewModel {
    
    func goToFetch() {
        coordinator.navigate(to: .home(.goToFetch))
    }
    
    func goToLogin() {
        coordinator.navigate(to: .home(.goToLogin))
    }
    
    func goToSettings() {
        coordinator.navigate(to: .home(.goToSettings))
    }
    
}

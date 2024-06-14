//
//  HomeViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import Foundation

@MainActor
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
    
    func goToUserLoginMode() async {
        await coordinator.navigate(to: .home(.goToUserLoginMode))
    }

    func goToAPIServerMode() async {
        await coordinator.navigate(to: .home(.goToAPIServerMode))
    }

    func goToUserProfileMode() async {
        await coordinator.navigate(to: .home(.goToUserProfile))
    }
    
}

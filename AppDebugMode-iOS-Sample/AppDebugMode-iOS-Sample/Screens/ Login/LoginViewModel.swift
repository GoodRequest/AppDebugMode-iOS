//
//  LoginViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import Combine
#if DEBUG
import AppDebugMode
#endif

final class LoginViewModel {
    
    // MARK: - Constants
    
    private let coordinator: Coordinator<AppStep>

    // MARK: - Initializer
    
    init(coordinator: Coordinator<AppStep>) {
        self.coordinator = coordinator
    }
    
}

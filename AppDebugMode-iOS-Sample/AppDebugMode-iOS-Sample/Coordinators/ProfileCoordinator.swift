//
//  SettingsCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import UIKit

enum ProfileStep { }

final class ProfileCoordinator: Coordinator<AppStep> {

    private let di: DependencyContainer

    init(di: DependencyContainer, rootViewController: UINavigationController?) {
        self.di = di
        super.init(rootViewController: rootViewController)
    }

    override func start() -> UIViewController? {
        let fetchViewModel = ProfileViewModel(di: di, coordinator: self)
        let fetchViewController = ProfileViewController(viewModel: fetchViewModel)

        return fetchViewController
    }

}

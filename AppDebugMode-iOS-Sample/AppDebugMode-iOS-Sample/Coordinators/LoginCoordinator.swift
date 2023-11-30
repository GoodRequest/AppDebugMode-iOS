//
//  LoginCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit

enum LoginStep { }

final class LoginCoordinator: Coordinator<AppStep> {

    private let di: DependencyContainer

    init(di: DependencyContainer, rootViewController: UINavigationController?) {
        self.di = di
        super.init(rootViewController: rootViewController)
    }

    override func start() -> UIViewController? {
        let fetchViewModel = LoginViewModel(coordinator: self)
        let fetchViewController = LoginViewController(viewModel: fetchViewModel)

        return fetchViewController
    }

}

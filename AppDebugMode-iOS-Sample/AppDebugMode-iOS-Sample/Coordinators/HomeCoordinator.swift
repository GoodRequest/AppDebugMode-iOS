//
//  HomeCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit

enum HomeStep {
    
    case goToFetch
    case goToLogin
    
}

final class HomeCoordinator: Coordinator<AppStep> {

    private let di: DependencyContainer

    init(di: DependencyContainer) {
        self.di = di
        super.init(rootViewController: UINavigationController())
    }

    override func start() -> UIViewController? {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)

        navigationController?.viewControllers = [homeViewController]

        return rootViewController
    }

    override func navigate(to stepper: AppStep) {
        switch stepper {
        case .home(let homeStep):
            navigate(to: homeStep)
        }
    }

    func navigate(to step: HomeStep) {
        switch step {
        case .goToFetch:
            guard let fetchViewController = FetchCoordinator(
                di: di,
                rootViewController: rootNavigationController
            ).start()
            else {
                return
            }
            
            navigationController?.pushViewController(fetchViewController, animated: true)
            
        case .goToLogin:
            guard let loginViewController = LoginCoordinator(
                di: di,
                rootViewController: rootNavigationController
            ).start()
            else {
                return
            }
            
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }

}


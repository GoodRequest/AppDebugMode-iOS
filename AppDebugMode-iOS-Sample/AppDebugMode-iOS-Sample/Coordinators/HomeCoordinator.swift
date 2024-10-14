//
//  HomeCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit

enum HomeStep {
    
    case goToAPIServerMode
    case goToUserLoginMode
    case goToUserProfile
    
}

@MainActor
final class HomeCoordinator: Coordinator<AppStep> {

    init() {
        super.init(rootViewController: UINavigationController())
    }

    override func start() async -> UIViewController? {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)

        navigationController?.viewControllers = [homeViewController]

        return rootViewController
    }

    override func navigate(to stepper: AppStep) async {
        switch stepper {
        case .home(let homeStep):
            await navigate(to: homeStep)
        }
    }

    func navigate(to step: HomeStep) async {
        switch step {
        case .goToAPIServerMode:
            let controller = ApiServerModeView(viewModel: .init()).eraseToUIViewController()
            navigationController?.pushViewController(controller, animated: true)

        case .goToUserLoginMode:
            navigationController?.pushViewController(LoginView().eraseToUIViewController(), animated: true)

        case .goToUserProfile:
            navigationController?.pushViewController(ProfileView().eraseToUIViewController(), animated: true)
        }
    }

}


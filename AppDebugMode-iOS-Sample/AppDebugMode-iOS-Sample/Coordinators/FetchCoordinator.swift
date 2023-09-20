//
//  HomeCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit

enum FetchStep { }

final class FetchCoordinator: Coordinator<AppStep> {

    private let di: DependencyContainer

    init(di: DependencyContainer, rootViewController: UINavigationController?) {
        self.di = di
        super.init(rootViewController: rootViewController)
    }

    override func start() -> UIViewController? {
        let fetchViewModel = FetchViewModel(di: di, coordinator: self)
        let fetchViewController = FetchViewController(viewModel: fetchViewModel)

        return fetchViewController
    }

}

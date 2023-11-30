//
//  AppCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit

enum AppStep {

    case home(HomeStep)

}

final class AppCoordinator: Coordinator<AppStep> {
    
    private let window: UIWindow?
    private let di: DependencyContainer

    init(window: UIWindow?, di: DependencyContainer) {
        self.window = window
        self.di = di
    }

    @discardableResult
    override func start() -> UIViewController? {
        window?.rootViewController = HomeCoordinator(di: di).start()
        window?.makeKeyAndVisible()

        return nil
    }
    
}

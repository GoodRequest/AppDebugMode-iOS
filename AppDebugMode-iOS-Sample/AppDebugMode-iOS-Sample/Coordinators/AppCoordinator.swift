//
//  AppCoordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit

enum AppStep: Sendable {

    case home(HomeStep)

}

@MainActor
final class AppCoordinator: Coordinator<AppStep> {
    
    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    @discardableResult
    override func start() async -> UIViewController? {
        window?.rootViewController = await HomeCoordinator().start()
        window?.makeKeyAndVisible()

        return nil
    }
    
}

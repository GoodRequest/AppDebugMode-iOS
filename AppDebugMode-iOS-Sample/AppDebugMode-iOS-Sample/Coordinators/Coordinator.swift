//
//  Coordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit

@MainActor
class Coordinator<Step: Sendable> {

    var rootViewController: UIViewController?

    var rootNavigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }

    var navigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }

    func start() async -> UIViewController? {
        return rootViewController
    }

    init(rootViewController: UIViewController? = nil) {
        self.rootViewController = rootViewController
    }

    func navigate(to stepper: Step) async {}

}

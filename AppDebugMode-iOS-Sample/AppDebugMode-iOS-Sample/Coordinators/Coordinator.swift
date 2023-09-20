//
//  Coordinator.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit

class Coordinator<Step> {

    var rootViewController: UIViewController?

    var rootNavigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }

    var navigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }

    func start() -> UIViewController? {
        return rootViewController
    }

    init(rootViewController: UIViewController? = nil) {
        self.rootViewController = rootViewController
    }

    func navigate(to stepper: Step) {}

}

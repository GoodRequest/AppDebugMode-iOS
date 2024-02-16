//
//  AppDelegate.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit
#if DEBUG
import AppDebugMode
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var dependencyContainer = DependencyContainer()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        
        #if DEBUG
        AppDebugModeProvider.shared.setup(
            serversCollections: Constants.ServersCollections.allClases,
            onServerChange: { debugPrint("Server has been changed") },
            cacheManager: dependencyContainer.cacheManager
        )


        if StandardOutputService.shared.shouldRedirectLogsToAppDebugMode {
            StandardOutputService.shared.redirectLogsToAppDebugMode()
        }
        #endif
        
        AppCoordinator(window: window, di: dependencyContainer).start()
        return true
    }


}


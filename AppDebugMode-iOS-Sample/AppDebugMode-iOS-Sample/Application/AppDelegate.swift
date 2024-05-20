//
//  AppDelegate.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import SwiftUI
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

        var isOn = false

        #if DEBUG
        AppDebugModeProvider.shared.setup(
            serversCollections: Constants.ServersCollections.allClases,
            onServerChange: { debugPrint("Server has been changed") },
            cacheManager: dependencyContainer.cacheManager,
            customControls: {
                [
                    .button(text: "Print isOn", action: { print("Toggle is on: \(isOn)") }),
                    .toggle(
                        title: "Toggle is on",
                        isOn: Binding(
                            get: { isOn },
                            set: { newValue in isOn = newValue }
                        )
                    ),
                    .toggle(
                        title: "Toggle is on 2",
                        isOn: Binding(
                            get: { isOn },
                            set: { newValue in isOn = newValue }
                        )
                    )
                ]
            }
        )
        #endif
        
        AppCoordinator(window: window, di: dependencyContainer).start()
        return true
    }


}


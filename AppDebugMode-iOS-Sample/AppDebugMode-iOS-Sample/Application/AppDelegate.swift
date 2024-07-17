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

    #if DEBUG
    var model: CustomControlsModel = CustomControlsModel()
    #endif

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow()

        #if DEBUG
        AppDebugModeProvider.shared.setup(
            serversCollections: Constants.ServersCollections.allClases,
            onServerChange: { debugPrint("Server has been changed") },
            cacheManager: dependencyContainer.cacheManager,
            customControls: { CustomControlsView(model: model) }
        )
        #endif
        
        AppCoordinator(window: window, di: dependencyContainer).start()
        return true
    }

}

#if DEBUG
final class CustomControlsModel: ObservableObject {

    @Published var isOn: Bool = false

}

struct CustomControlsView: View {

    @ObservedObject var model: CustomControlsModel

    var body: some View {
        VStack(spacing: 20) {
            Button {
                print("IsOn: \(model.isOn)")
            } label: {
                Text("Print is on: \(model.isOn)")
            }

            Toggle("Toggle is on", isOn: $model.isOn)
            Toggle("Toggle is on", isOn: $model.isOn)

            NavigationLink {
                Text("Hello")
            } label: {
                Text("Click me")
            }
        }
    }

}
#endif

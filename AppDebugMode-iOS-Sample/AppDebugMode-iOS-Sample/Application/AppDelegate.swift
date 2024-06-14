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
import Factory

@main
@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    #if DEBUG
    var model: CustomControlsModel = CustomControlsModel()
    #endif

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow()

        #if DEBUG
        Task {
            let providers = [
                DebugSelectableServerProvider(
                apiServerPickerConfiguration: .init(
                    serversCollections: Constants.devServerCollection,
                    onSelectedServerChange: nil
                    )
                ),
                DebugSelectableServerProvider(
                apiServerPickerConfiguration: .init(
                    serversCollections: Constants.testServerCollection,
                    onSelectedServerChange: nil
                    )
                )
            ]

            await PackageManager.shared.setup(
                serverProviders: providers,
                configurableProxySessionProvider: Container.shared.configurableSessionProvider.resolve(),
                customControls: CustomControlsView(model: model),
                showDebugSwift: true
            )
        }

        #endif

        Task {
            await AppCoordinator(window: window).start()
        }
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

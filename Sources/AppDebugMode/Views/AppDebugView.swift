//
//  AppDebugView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI
import Factory
import PulseUI
import DebugSwift

struct AppDebugView<CustomControls: View>: View {

    // MARK: - Factory

    @Injected(\.packageManager) private var packageManager: PackageManager
    @Injected(\.profileProvider) private var profileProvider: UserProfilesProvider
    @Injected(\.apnsProviding) private var apnsProvider: PushNotificationsProvider?

    // MARK: - Environtment

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.hostingControllerHolder) var viewControlleeHolder

    // MARK: - State

    @State private var userDefaultValues: [String : String] = [:]
    @State private var keychainValues: [String : String] = [:]

    // MARK: - Properties
    
    private var screens: [Screen] = []
    private var customControls: CustomControls
    private var customControlsViewIsVisible: Bool

    // MARK: - Structs

    struct Screen {
        
        let title: String
        let image: Image
        let destination: AnyView
        
    }
    
    // MARK: - Init
    
    init(
        customControls: CustomControls,
        customControlsViewIsVisible: Bool
    ) {
        self.customControls = customControls
        self.customControlsViewIsVisible = customControlsViewIsVisible

        self.screens.append(Screen(
            title: "Server settings",
            image: Image(systemName: "server.rack"),
            destination: AnyView(ServersCollectionsView())
        ))

        self.screens.append(Screen(
            title: "User profiles",
            image: Image(systemName: "person.2"),
            destination: AnyView(UserProfilesPickerView(viewModel: .init()))
        ))

        if let apnsProvider {
            self.screens.append(Screen(
                title: "Push notifications",
                image: Image(systemName: "bell.badge"),
                destination: AnyView(PushNotificationsSettingsView(pushNotificationsProvider: apnsProvider))
            ))
        }

        self.screens.append(Screen(
            title: "Pulse Logs",
            image: Image(systemName: "wave.3.forward"),
            destination: AnyView(PulseUI.ConsoleView().tint(AppDebugColors.primary))
        ))

        self.screens.append(contentsOf: [
            Screen(
                title: "App directory",
                image: Image(systemName: "folder"),
                destination: AnyView(AppDirectorySettingsView())
            ),
            Screen(
                title: "Logs",
                image: Image(systemName: "list.bullet.rectangle"),
                destination: AnyView(ConsoleLogsListView())
            )
        ])

        self.screens.append(
            Screen(
                title: "Connections",
                image: Image(systemName: "network"),
                destination: AnyView(erasing: ConnectionsSettingsView())
            )
        )
    }


    // MARK: - Body

    var body: some View {
        appDebugViewList()
            .navigationTitle("App Debug Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                closeNavigationBarItem()
            }
            .navigationViewStyle(.stack)
            .accentColor(AppDebugColors.primary)
            .onAppear {
                let appearanceProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [BaseHostingController.self])
                let standardAppearance = UINavigationBarAppearance()
                standardAppearance.backgroundEffect = UIBlurEffect(style: .dark)
                standardAppearance.titleTextAttributes = [
                    .foregroundColor: UIColor.white
                ]
                
                appearanceProxy.scrollEdgeAppearance = standardAppearance
                appearanceProxy.standardAppearance = standardAppearance
            }
        
    }

}

// MARK: - Components

private extension AppDebugView {
    
    // MARK: - List
    
    func appDebugViewList() -> some View {
        List {
            settingsSection()
            if customControlsViewIsVisible {
                customControlsSection()
            }
            dangerZoneSection()
        }
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }
    
    @ViewBuilder
    func navigationLink(screen: Screen) -> some View {
        Button {
            let viewController = screen.destination.eraseToUIViewController()
            viewControlleeHolder?.controller?.navigationController?.pushViewController(viewController, animated: false)
        } label: {
            HStack {
                screen.image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(AppDebugColors.primary)
                    .frame(width: 16, height: 16)
                Text(screen.title)
            }
        }
    }
    
    // MARK: - Sections
    
    func settingsSection() -> some View {
        Section {
            ForEach(screens, id: \.title) { screen in
                navigationLink(screen: screen)
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
                    .foregroundColor(AppDebugColors.textPrimary)
            }
        } header: {
            Text("Settings")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }

    func customControlsSection() -> some View {
        Section {
            customControls
                .foregroundColor(AppDebugColors.textPrimary)
                .buttonStyle(ButtonControlStyle())
                .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Custom controls")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }

    func dangerZoneSection() -> some View {
        Section {
            ResetAppView()
                .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Danger zone")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    // MARK: - Navigation Bar Items
    
    @ToolbarContentBuilder
    func closeNavigationBarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if #available(iOS 15, *) {
                Button {
                    viewControlleeHolder?.controller?.navigationController?.dismiss(animated: true)
                } label: {
                    Text("Close")
                }
            } else {
                EmptyView()
            }
        }
    }

}

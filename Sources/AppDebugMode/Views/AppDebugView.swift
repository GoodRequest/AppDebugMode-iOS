//
//  AppDebugView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

struct AppDebugView<CustomControls: View>: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.hostingControllerHolder) var viewControlleeHolder
    
    // MARK: - Properties
    
    private var screens: [Screen]
    let customControls: CustomControls
    let customControlsViewIsVisible: Bool

    struct Screen {
        
        let title: String
        let image: Image
        let destination: AnyView
        
    }
    
    // MARK: - Init
    
    init(serversCollections: [ApiServerCollection], customControls: CustomControls, customControlsViewIsVisible: Bool) {
        self.screens = []

        if !AppDebugModeProvider.shared.serversCollections.isEmpty {
            self.screens.append(Screen(
                title: "Server settings",
                image: Image(systemName: "server.rack"),
                destination: AnyView(ServersCollectionsView(
                    viewModel: ServersCollectionsViewModel(
                        serversCollections: serversCollections
                    )
                ))
            ))
        }

        self.screens.append(Screen(
            title: "User profiles",
            image: Image(systemName: "person.2"),
            destination: AnyView(UserProfilesPickerView())
        ))

        if let pushNotificationsProvider = AppDebugModeProvider.shared.pushNotificationsProvider {
            self.screens.append(Screen(
                title: "Push notifications",
                image: Image(systemName: "bell.badge"),
                destination: AnyView(PushNotificationsSettingsView(pushNotificationsProvider: pushNotificationsProvider))
            ))
        }

        if !CacheProvider.shared.userDefaultValues.isEmpty {
            self.screens.append(Screen(
                title: "User defaults",
                image: Image(systemName: "externaldrive"),
                destination: AnyView(UserDefaultsSettingsView())
            ))
        }

        if !CacheProvider.shared.keychainValues.isEmpty {
            self.screens.append(Screen(
                title: "Keychain settings",
                image: Image(systemName: "key"),
                destination: AnyView(KeychainSettingsView())
            ))
        }

        self.screens.append(contentsOf: [
            Screen(
                title: "App directory",
                image: Image(systemName: "folder"),
                destination: AnyView(AppDirectorySettingsView())
            ),
            Screen(
                title: "Logs",
                image: Image(systemName: "list.bullet.rectangle"),
                destination: AnyView(ConsoleLogsView())
            )
        ])

        self.customControls = customControls
        self.customControlsViewIsVisible = customControlsViewIsVisible
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

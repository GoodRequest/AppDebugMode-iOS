//
//  AppDebugView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

struct AppDebugView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Properties
    
    private var screens: [Screen]
    
    struct Screen {
        
        let title: String
        let image: Image
        let destination: AnyView
        
    }
    
    // MARK: - Init
    
    init(serversCollections: [ApiServerCollection]) {
        self.screens = [
            Screen(
                title: "Server settings",
                image: Image(systemName: "server.rack"),
                destination: AnyView(ServersCollectionsView(
                    viewModel: ServersCollectionsViewModel(
                        serversCollections: serversCollections
                    )
                ))
            ),
            Screen(
                title: "User profiles",
                image: Image(systemName: "person.2"),
                destination: AnyView(UserProfilesPickerView())
            )
        ]
        
        if let pushNotificationsProvider = AppDebugModeProvider.shared.pushNotificationsProvider {
            self.screens.append(Screen(
                title: "Push notifications",
                image: Image(systemName: "bell.badge"),
                destination: AnyView(PushNotificationsSettingsView(pushNotificationsProvider: pushNotificationsProvider))
            ))
        }
        
        self.screens.append(contentsOf: [
            Screen(
                title: "User defaults",
                image: Image(systemName: "externaldrive"),
                destination: AnyView(UserDefaultsSettingsView())
            ),
            Screen(
                title: "Keychain settings",
                image: Image(systemName: "key"),
                destination: AnyView(KeychainSettingsView())
            ),
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
    }
    

    // MARK: - Body

    var body: some View {
        NavigationView {
            appDebugViewList()
                .navigationTitle("App Debug Mode")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    closeNavigationBarItem()
                }
        }
        .navigationViewStyle(.stack)
        .accentColor(AppDebugColors.primary)
        .onAppear {
            let appearanceProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [UIHostingController<AppDebugView>.self])
            appearanceProxy.tintColor = UIColor(AppDebugColors.primary)
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
            dangerZoneSection()
        }
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }
    
    func navigationLink(screen: Screen) -> some View {
        NavigationLink {
            screen.destination
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
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                }
            } else {
                EmptyView()
            }
        }
    }

}

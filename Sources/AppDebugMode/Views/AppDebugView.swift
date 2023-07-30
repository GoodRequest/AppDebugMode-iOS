//
//  File.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

// MARK: - App Debug View

struct AppDebugView: View {

    // MARK: - State

    @State private var showServerSettings = false
    @State private var showUserProfiles = false
    @State private var showCacheSettings = false
    @State private var showKeychainSettings = false
    @State private var showAppDirectorySettings = false
    
    // MARK: - Properties
    
    let serversCollections: [ApiServerCollection]

    // MARK: - Body

    var body: some View {
        List {
            serverPickerSection()
            userProfilesSection()
            cacheSettingsSection()
            keychainSettingsSection()
            appDirectorySettingsSection()

            ResetAppView()
        }
        .listStyle(.insetGrouped)
        .dismissKeyboardOnDrag()
    }

}

// MARK: - Components

private extension AppDebugView {

    func serverPickerSection() -> some View {
        Section {
            if showServerSettings {
                ServersCollectionsView(viewModel: ServersCollectionsViewModel(serversCollections: serversCollections))
            }
        } header: {
            ExpandableHeaderView(title: "Server settings", isExpanded: $showServerSettings)
        }
    }

    func userProfilesSection() -> some View {
        Section {
            if showUserProfiles {
                TestingUserPickerView()
            }
        } header: {
            ExpandableHeaderView(title: "Testing User profiles", isExpanded: $showUserProfiles)
        }
    }

    func cacheSettingsSection() -> some View {
        Section {
            if showCacheSettings {
                CacheSettingsView()
            }
        } header: {
            ExpandableHeaderView(title: "Cache settings", isExpanded: $showCacheSettings)
        }
    }
    
    func keychainSettingsSection() -> some View {
        Section {
            if showKeychainSettings {
                KeychainSettingsView()
            }
        } header: {
            ExpandableHeaderView(title: "Keychain settings", isExpanded: $showKeychainSettings)
        }
    }
    
    func appDirectorySettingsSection() -> some View {
        Section {
            if showAppDirectorySettings {
                AppDirectorySettingsView()
            }
        } header: {
            ExpandableHeaderView(title: "App Directory Settings", isExpanded: $showAppDirectorySettings)
        }
    }

    struct ExpandableHeaderView: View {
        let title: String
        @Binding var isExpanded: Bool

        var body: some View {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.up")
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                }
            }
        }
    }

}

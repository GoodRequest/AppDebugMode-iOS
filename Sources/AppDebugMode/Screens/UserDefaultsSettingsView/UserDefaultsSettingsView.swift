//
//  UserDefaultsSettingsView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct UserDefaultsSettingsView: View {
    
    @ObservedObject private var viewModel = UserDefaultsSettingsViewModel()
    @State private var isShowingConfirmationAlert = false
    @State private var isShowingCopiedAlert = false
    
    var body: some View {
        Group {
            if #available(iOS 15, *) {
                userDefaultsList()
                    .safeAreaInset(edge: .bottom) {
                        reloadCacheFooter()
                    }
            } else {
                ZStack(alignment: .bottom) {
                    userDefaultsList()
                    reloadCacheFooter()
                }
            }
        }
        .navigationTitle("User defaults")
        .copiedAlert(isPresented: $isShowingCopiedAlert)
        .alert(isPresented: $isShowingConfirmationAlert, content: clearUserDefaultsConfirmationAlert)
    }

}

// MARK: - Components

private extension UserDefaultsSettingsView {

    func userDefaultsList() -> some View {
        List {
            cacheValuesSection()
            dangerZoneSection()
        }
        .listStyle(.insetGrouped)
        .listContentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0), for: .insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }
    
    // MARK: - Cahce values section
    
    func cacheValuesSection() -> some View {
        Section {
            ForEach(viewModel.userDefaultValues, id: \.key) { key, value in
                CacheValueListItemView(key: key, value: value, isShowingCopiedAlert: $isShowingCopiedAlert)
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
            }
        } header: {
            Text("User defaults values")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    // MARK: - Danger zone
    
    func dangerZoneSection() -> some View {
        Section {
            VStack(spacing: 16) {
                ButtonFilled(text: "Clear user defaults", style: .danger) {
                    isShowingConfirmationAlert = true
                }
                Text("The app will be restarted after clearing the user defaults.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Danger zone")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    // MARK: - Footer
    
    func reloadCacheFooter() -> some View {
        VStack(spacing: 10) {
            ButtonFilled(text: "Reload user defaults") {
                viewModel.reloadUserDefaults()
            }

            Text("Reload data from the user defaults.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(AppDebugColors.textSecondary)
        }
        .padding(16)
        .background(Glass().edgesIgnoringSafeArea(.bottom))
    }
    
    // MARK: - Alert
    
    func clearUserDefaultsConfirmationAlert() -> Alert {
        Alert(
            title: Text("Do you really want to clear user defaults?"),
            message: Text("This action cannot be undone."),
            primaryButton: .destructive(Text("Yes, clear user defaults")) {
                viewModel.clearUserDefaults()
                exit(0)
            },
            secondaryButton: .cancel()
        )
    }
    
}

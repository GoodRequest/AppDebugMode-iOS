//
//  KeychainSettingsView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct KeychainSettingsView: View {
    
    @ObservedObject private var viewModel = KeychainSettingsViewModel()
    @State private var isShowingCopiedAlert = false
    
    var body: some View {
        Group {
            if #available(iOS 15, *) {
                keychainList()
                    .safeAreaInset(edge: .bottom) {
                        reloadKeychainFooter()
                    }
            } else {
                ZStack(alignment: .bottom) {
                    keychainList()
                    reloadKeychainFooter()
                }
            }
        }
        .navigationTitle("Keychain settings")
        .copiedAlert(isPresented: $isShowingCopiedAlert)
        .alert(item: $viewModel.alert) { alert in
            switch alert {
            case .clearKeychainError:
                return clearKeychainErrorAlert()

            case .confirmation:
                return clearKeychainConfirmationAlert()
            }
        }
    }

}

// MARK: - Components

private extension KeychainSettingsView {

    func keychainList() -> some View {
        List {
            keychainValuesSection()
            dangerZoneSection()
        }
        .listStyle(.insetGrouped)
        .listContentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0), for: .insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }
    
    // MARK: - Keychain values
    
    func keychainValuesSection() -> some View {
        Section {
            ForEach(viewModel.keychainValues, id: \.key) { key, value in
                CacheValueListItemView(key: key, value: value, isShowingCopiedAlert: $isShowingCopiedAlert)
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
            }
        } header: {
            Text("Keychain values")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    // MARK: - Danger zone
    
    func dangerZoneSection() -> some View {
        Section {
            VStack {
                ButtonFilled(text: "Clear keychain data", style: .danger) {
                    viewModel.alert = .confirmation
                }
                Text("The app will be restarted after clearing the keychain.")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.gray)
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Actions")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    // MARK: - Footer
    
    func reloadKeychainFooter() -> some View {
        VStack(spacing: 10) {
            ButtonFilled(text: "Reload keychain data") {
                viewModel.reloadKeychain()
            }
            Text("Reload data from the keychain.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(AppDebugColors.textSecondary)
        }
        .padding(16)
        .background(Glass().edgesIgnoringSafeArea(.bottom))
    }
    
    // MARK: - Alerts
    
    func clearKeychainConfirmationAlert() -> Alert {
        Alert(
            title: Text("Do you really want to clear the keychain?"),
            message: Text("This action cannot be undone."),
            primaryButton: .destructive(Text("Yes, clear keychain")) {
                viewModel.clearKeychain()
            },
            secondaryButton: .cancel()
        )
    }
    
    func clearKeychainErrorAlert() -> Alert {
        Alert(
            title: Text("Error"),
            message: Text("Keychain data could not be cleared."),
            dismissButton: .default(Text("OK"))
        )
    }
    
}

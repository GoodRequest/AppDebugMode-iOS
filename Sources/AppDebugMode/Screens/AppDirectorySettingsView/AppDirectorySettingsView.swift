//
//  AppDirectorySettingsView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct AppDirectorySettingsView: View {
    
    @ObservedObject private var viewModel = AppDirectorySettingsViewModel()
    
    var body: some View {
        List {
            actionsSection()
            dangerZoneSection()
        }
        .navigationTitle("App directory")
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
        .alert(item: $viewModel.alert) { alert in
            switch alert {
            case .clearDirectoryConfrimation:
                return clearAppDirectoryConfirmationAlert()
                
            case .clearDirectoryError(let error):
                return clearDirectoryErrorAlert(error: error)
            }
        }
    }
    
}

// MARK: - Components

private extension AppDirectorySettingsView {

    // MARK: - Sections

    func actionsSection() -> some View {
        Section {
            VStack {
                ButtonFilled(text: "Open App Files Directory") {
                    viewModel.openAppFilesDirectory()
                }
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Actions")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    func dangerZoneSection() -> some View {
        Section {
            VStack {
                ButtonFilled(text: "Clear App Files Directory", style: .danger) {
                    viewModel.alert = .clearDirectoryConfrimation
                }
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Danger zone")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }
    
    // MARK: - Alerts
    
    func clearDirectoryErrorAlert(error: Error) -> Alert {
        Alert(
            title: Text("Could not clear directory"),
            message: Text(error.localizedDescription)
        )
    }
    
    func clearAppDirectoryConfirmationAlert() -> Alert {
        Alert(
            title: Text("Do you really want to clear app files directory?"),
            message: Text("This action cannot be undone."),
            primaryButton: .destructive(Text("Yes, clear app files directory")) {
                viewModel.clearAppFilesDirectory()
            },
            secondaryButton: .cancel()
        )
    }
    
}

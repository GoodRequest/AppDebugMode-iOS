//
//  ResetAppView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI
import Factory

struct ResetAppView: View {

    @ObservedObject private var appDirectoryViewModel = AppDirectorySettingsViewModel()
    
    @State private var isShowingConfirmationAlert = false

    var body: some View {
        VStack {
            ButtonFilled(text: "Remove All App Data", style: .danger) {
                isShowingConfirmationAlert = true
            }
            
            Text("This will remove all app data, including user defaults, keychain and app files directory.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
        }
        .alert(isPresented: $isShowingConfirmationAlert, content: confirmationAlert)
    }
    
}

// MARK: - Components

private extension ResetAppView {
    
    func confirmationAlert() -> Alert {
        Alert(
            title: Text("Do you really want to erase all app data?"),
            message: Text("This action cannot be undone."),
            primaryButton: .destructive(Text("Yes, erase all data")) {
                appDirectoryViewModel.clearAppFilesDirectory()
                exit(0)
            },
            secondaryButton: .cancel()
        )
    }
    
}

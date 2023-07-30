//
//  File.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct AppDirectorySettingsView: View {
    
    @ObservedObject private var viewModel = AppDirectorySettingsViewModel()
    
    var body: some View {
        VStack {
            PrimaryButton(text: "Open App Files Directory") {
                viewModel.openAppFilesDirectory()
            }
            PrimaryButton(text: "Clear App Files Directory", style: .danger) {
                viewModel.clearAppFilesDirectory()
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Could not clear directory"),
                message: Text(viewModel.error?.localizedDescription ?? "Please try again later")
            )
        }
    }
    
}

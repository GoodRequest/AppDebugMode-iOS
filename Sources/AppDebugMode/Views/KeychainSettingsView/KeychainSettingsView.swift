//
//  File.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct KeychainSettingsView: View {
    
    @ObservedObject private var viewModel = KeychainSettingsViewModel()
    
    var body: some View {
        VStack {
            PrimaryButton(text: "Clear keychain data", style: .danger) {
                viewModel.clearKeychain()
                exit(0)
            }
            Text("The app will be restarted after clearing the keychain.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text("Error"), message: Text("Keychain data could not be cleared."), dismissButton: .default(Text("OK")))
        }
    }

}

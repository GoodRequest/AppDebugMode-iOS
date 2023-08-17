//
//  KeychainSettingsView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct KeychainSettingsView: View {
    
    @ObservedObject private var viewModel = KeychainSettingsViewModel()
    
    var body: some View {
        Group {
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
            ForEach(viewModel.keychainValues, id: \.key) { key, value in
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button {
                            UIPasteboard.general.string = value
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                        }
                    }
                    Text("\(key) - \(value)")
                }
            }
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text("Error"), message: Text("Keychain data could not be cleared."), dismissButton: .default(Text("OK")))
        }
    }

}

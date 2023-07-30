//
//  ResetAppView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct ResetAppView: View {
    
    @ObservedObject private var cacheViewModel = CacheSettingsViewModel()
    @ObservedObject private var keychainViewModel = KeychainSettingsViewModel()
    @ObservedObject private var appDirectoryViewModel = AppDirectorySettingsViewModel()
    
    var body: some View {
        VStack {
            PrimaryButton(text: "Remove All App Data", style: .danger) {
                cacheViewModel.clearCache()
                keychainViewModel.clearKeychain()
                appDirectoryViewModel.clearAppFilesDirectory()
                exit(0)
            }
            
            Text("The app will be restarted.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
        }
    }
    
}

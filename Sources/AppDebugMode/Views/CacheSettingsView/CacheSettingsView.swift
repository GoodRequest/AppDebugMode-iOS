//
//  CacheSettingsView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct CacheSettingsView: View {
    
    @ObservedObject private var viewModel = CacheSettingsViewModel()
    
    var body: some View {
        Group {
            VStack {
                PrimaryButton(text: "Clear cache", style: .danger) {
                    viewModel.clearCache()
                    exit(0)
                }
                Text("The app will be restarted after clearing the cache.")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.gray)
            }
         
            ForEach(viewModel.cacheValues, id: \.key) { key, value in
                Text("\(key) - \(viewModel.formatValueToString(value: value))")
            }
        }
    }

}

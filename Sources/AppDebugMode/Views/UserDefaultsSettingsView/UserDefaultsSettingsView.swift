//
//  UserDefaultsSettingsView.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import SwiftUI

struct UserDefaultsSettingsView: View {
    
    @ObservedObject private var viewModel = UserDefaultsSettingsViewModel()
    
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
            ForEach(viewModel.userDefaultValues, id: \.key) { key, value in
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
    }

}

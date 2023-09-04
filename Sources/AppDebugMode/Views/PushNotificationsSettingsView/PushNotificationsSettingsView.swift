//
//  PushNotificationsSettingsView.swift
//  
//
//  Created by Matus Klasovity on 31/07/2023.
//

import SwiftUI

struct PushNotificationsSettingsView: View {
    
    @ObservedObject var viewModel: PushNotificationsSettingsViewModel
    
    init(pushNotificationsProvider: PushNotificationsProvider) {
        self.viewModel = PushNotificationsSettingsViewModel(pushNotificationsProvider: pushNotificationsProvider)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Token: ").bold() + Text(viewModel.token ?? "")

                Button {
                    viewModel.copyTokenToClipboard()
                } label: {
                    Image(systemName: "doc.on.doc")
                }
            }
            PrimaryButton(text: "Refresh token") {
                viewModel.refreshToken()
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "")
            )
        }
    }

}

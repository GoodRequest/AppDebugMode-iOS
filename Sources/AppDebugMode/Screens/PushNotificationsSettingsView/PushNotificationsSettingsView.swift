//
//  PushNotificationsSettingsView.swift
//  
//
//  Created by Matus Klasovity on 31/07/2023.
//

import SwiftUI

struct PushNotificationsSettingsView: View {
    
    @ObservedObject var viewModel: PushNotificationsSettingsViewModel
    
    init(pushNotificationsProvider: FirebaseMessagingProvider) {
        self.viewModel = PushNotificationsSettingsViewModel(pushNotificationsProvider: pushNotificationsProvider)
    }
    
    var body: some View {
        Group {
            if #available(iOS 15, *) {
                pushNotificationsSettingsList()
                    .safeAreaInset(edge: .bottom) {
                        buttonsFooterView()
                    }
            } else {
                ZStack(alignment: .bottom) {
                    pushNotificationsSettingsList()
                    buttonsFooterView()
                }
            }
        }
        .navigationTitle("Push notifications settings")
        .onAppear { viewModel.refreshToken(shouldRegenerate: false) }
        .copiedAlert(isPresented: $viewModel.isShowingCopiedAlert)
        .alert(isPresented: $viewModel.hasError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error?.localizedDescription ?? "")
            )
        }
    }

}

// MARK: - Components

private extension PushNotificationsSettingsView {
    
    func pushNotificationsSettingsList() -> some View {
        List {
            pushNotificationsTokenView()
                .listRowBackground(AppDebugColors.backgroundSecondary)
        }
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }
    
    func pushNotificationsTokenView() -> some View {
        Button {
            viewModel.copyTokenToClipboard()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Token")
                        .bold()
                        .foregroundColor(AppDebugColors.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "doc.on.doc")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(AppDebugColors.primary)
                        .frame(width: 20, height: 20)
                }
                
                Text(viewModel.token ?? "")
                    .foregroundColor(AppDebugColors.textPrimary)
            }
        }.buttonStyle(.borderless)
    }

    func buttonsFooterView() -> some View {
        VStack(spacing: 8) {
            ButtonFilled(text: "Reload token") { viewModel.refreshToken(shouldRegenerate: false) }
            ButtonFilled(text: "Generate new token", style: .danger) { viewModel.refreshToken(shouldRegenerate: true) }
        }
        .padding(16)
        .background(Glass().edgesIgnoringSafeArea(.bottom))
    }
    
}

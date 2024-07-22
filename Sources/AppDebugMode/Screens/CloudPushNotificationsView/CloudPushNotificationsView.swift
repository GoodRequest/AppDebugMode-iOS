//
//  SwiftUIView.swift
//  
//
//  Created by Sebastian Mraz on 19/07/2024.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct CloudPushNotificationsView: View {
    
    // MARK: - Properties
    
    @ObservedObject private var viewModel = CloudPushNotificationsViewModel()
    @State private var isImporting = false

    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Certificate")
                    .font(.headline)
                    .foregroundColor(AppDebugColors.textSecondary)

                Button {
                    isImporting = true
                } label: {
                    if let name = viewModel.certificateName {
                        Text(name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                            )
                            .foregroundColor(AppDebugColors.textPrimary)
                    } else {
                        Text("Certificate")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                            )
                            .foregroundColor(AppDebugColors.textSecondary)
                    }
                }
                                 
                TextField("", text: $viewModel.certificatePassword)
                    .introspect(.textField, on: .iOS(.v14...)) { textField in
                        textField.attributedPlaceholder = NSAttributedString(
                            string: "Certificate password",
                            attributes: [
                                .foregroundColor: UIColor(AppDebugColors.textSecondary)
                            ]
                        )
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)

                Text("Push notification type")
                    .font(.headline)
                    .foregroundColor(AppDebugColors.textSecondary)
                
                Menu(viewModel.notificationType.title) {
                    Button(NotificationType.alert.title, action: { 
                        viewModel.notificationType = .alert
                        viewModel.customPayload = viewModel.notificationType.payload
                    })
                    Button(NotificationType.background.title, action: {
                        viewModel.notificationType = .background
                        viewModel.customPayload = viewModel.notificationType.payload
                    })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                )
                .foregroundColor(AppDebugColors.textPrimary)

                if !viewModel.customPayload.isEmpty {
                    Text("Payload")
                        .font(.headline)
                        .foregroundColor(AppDebugColors.textSecondary)
                    
                    ZStack {
                        TextEditor(text: $viewModel.customPayload)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                            )
                            .foregroundColor(AppDebugColors.textPrimary)
                            .frame(minHeight: 100)
                    }
                }
                
                Text("Optional parameters")
                    .font(.headline)
                    .foregroundColor(AppDebugColors.textSecondary)
                
                TextField("", text: $viewModel.deviceToken)
                    .introspect(.textField, on: .iOS(.v14...)) { textField in
                        textField.attributedPlaceholder = NSAttributedString(
                            string: "Device token",
                            attributes: [
                                .foregroundColor: UIColor(AppDebugColors.textSecondary)
                            ]
                        )
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)
                
                TextField("", text: $viewModel.appId)
                    .introspect(.textField, on: .iOS(.v14...)) { textField in
                        textField.attributedPlaceholder = NSAttributedString(
                            string: "App id",
                            attributes: [
                                .foregroundColor: UIColor(AppDebugColors.textSecondary)
                            ]
                        )
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)
            }
            .padding(16)
            .padding(.bottom, 64)
        }
        .fileImporter(isPresented: $isImporting,
                      allowedContentTypes: [.pkcs12]) {
            let result = $0.flatMap { url in
                viewModel.read(from: url)
            }
            switch result {
            case let .success(data):
                viewModel.certificate = data
            default:
                break
            }
        }
        .overlay(
            ButtonFilled(text: "Send cloud notification") {
                viewModel.send()
            }
            .padding(),
            alignment: .bottom
        )
        .navigationTitle("Cloud push notifications")
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
        .alert(item: $viewModel.validationError) { validationError in
            Alert(
                title: Text("Validation error"),
                message: Text(validationError.localizedDescription),
                dismissButton: .cancel()
            )
        }
    }
}

#Preview {
    CloudPushNotificationsView()
}

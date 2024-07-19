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

    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Certificate")
                    .font(.headline)
                    .foregroundColor(AppDebugColors.textSecondary)

                TextField("", text: $viewModel.certificate)
                    .introspect(.textField, on: .iOS(.v14...)) { textField in
                        textField.attributedPlaceholder = NSAttributedString(
                            string: "Certificate",
                            attributes: [
                                .foregroundColor: UIColor(AppDebugColors.textSecondary)
                            ]
                        )
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)
                
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
                    .keyboardType(.URL)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)

                Text("Push notification")
                    .font(.headline)
                    .foregroundColor(AppDebugColors.textSecondary)

                TextField("", text: $viewModel.pushTitle)
                    .introspect(.textField, on: .iOS(.v14...)) { textField in
                        textField.attributedPlaceholder = NSAttributedString(
                            string: "Push title",
                            attributes: [
                                .foregroundColor: UIColor(AppDebugColors.textSecondary)
                            ]
                        )
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)
                
                TextField("", text: $viewModel.pushBody)
                    .introspect(.textField, on: .iOS(.v14...)) { textField in
                        textField.attributedPlaceholder = NSAttributedString(
                            string: "Push body",
                            attributes: [
                                .foregroundColor: UIColor(AppDebugColors.textSecondary)
                            ]
                        )
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)
                
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
                    .keyboardType(.numberPad)
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
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                    )
                    .foregroundColor(AppDebugColors.textPrimary)
            }
            .padding(16)
        }
        .overlay(
            ButtonFilled(text: "Send cloud notification") {
                NotificationManager.shared.send()
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

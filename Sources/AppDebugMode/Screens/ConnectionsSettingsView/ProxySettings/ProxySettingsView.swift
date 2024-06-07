//
//  ProxySettingsView.swift
//
//
//  Created by Matus Klasovity on 28/05/2024.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct ProxySettingsView: View {

    @ObservedObject private var viewModel = ProxySettingsViewModel()

    var body: some View {
        Group {
            Text("""
                    Set up a proxy server to monitor network traffic.
                    The proxy server will be used only for the app.

                    To set up a proxy server, enter the IP address and port of the proxy server.
                    You can find the IP address and port in the **Debugman** app. You also **need to install certificates** on your device from debugman app and trust them.

                    To install certificates, open the Debugman app, go to the **Proxy Settings** -> **Share certificates**. Then use airDrop to send the certificates to your device and install them from the Settings app (similiar workflow to bitrise certificates installation). Then click the **Open Cert Trust Settings** button and enable the certificates.
                    """
            )
            .foregroundColor(AppDebugColors.textPrimary)
            .padding(.bottom, 8)

            TextField("", text: $viewModel.proxyIpAdress)
                .introspect(.textField, on: .iOS(.v14...)) { textField in
                    textField.attributedPlaceholder = NSAttributedString(
                        string: "Proxy ip address",
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

            TextField("", text: $viewModel.proxyPort)
                .introspect(.textField, on: .iOS(.v14...)) { textField in
                    textField.attributedPlaceholder = NSAttributedString(
                        string: "Proxy port",
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

            ButtonFilled(text: "Open Cert Trust Settings") {
                let url = URL(string: "App-prefs:General&path=About/CERT_TRUST_SETTINGS")!
                UIApplication.shared.open(url)
            }

            ButtonFilled(text: "Save proxy settings") {
                viewModel.saveProxySettings()
            }
        }
        .alert(item: $viewModel.validationError) { validationError in
            Alert(
                title: Text("Validation error"),
                message: Text(validationError.localizedDescription),
                dismissButton: .cancel()
            )
        }
    }

}

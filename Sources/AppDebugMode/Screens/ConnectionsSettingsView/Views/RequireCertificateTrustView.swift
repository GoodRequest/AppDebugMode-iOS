//
//  RequireCertificateTrustView.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 18/06/2024.
//

import SwiftUI
import Factory

struct RequireCertificateTrustView: View {

    // MARK: - Factory

    @Injected(\.sessionManager) private var sessionManager: DebugManSessionManager

    // MARK: - Binded

    @Binding var error: (any Error)?

    // MARK: - Initialization

    init(error: Binding<(any Error)?>) {
        self._error = error
    }

    // MARK: - Body

    var body: some View {
        VStack {
            switch sessionManager.mitmProxyState {
            case .testing:
                ProgressView {
                    Text("Validating certificate...")
                }
                .foregroundStyle(AppDebugColors.textPrimary)
                .tint(AppDebugColors.textPrimary)

            case .waitingForUserToTrustMITMProxy:
                ButtonFilled(text: "Open certificate trust settings") {
                    let url = URL(string: "App-prefs:General&path=About/CERT_TRUST_SETTINGS")!
                    UIApplication.shared.open(url)
                }

                ButtonFilled(text: "Validate Saved Proxy Config") {
                    Task {
                        do {
                            try await sessionManager.validateSavedProxyConfiguration()
                        } catch {
                            self.error = error
                        }
                    }
                }
                ButtonFilled(text: "Request new certificate") {
                    Task {
                        do {
                            try await sessionManager.requestNewCertificate()
                        } catch {
                            self.error = error
                        }
                    }
                }
                ButtonFilled(text: "Request new config") {
                    Task {
                        do {
                            try await sessionManager.requestNewConfiguration()
                        } catch {
                            self.error = error
                        }
                    }
                }
                ButtonFilled(text: "Clean Config") {
                    Task {
                        do {
                            try sessionManager.cleanConfig()
                        } catch {
                            self.error = error
                        }
                    }
                }
            default:
                Text(verbatim: "Something is wront this state should not be possible")
            }
        }
    }

}

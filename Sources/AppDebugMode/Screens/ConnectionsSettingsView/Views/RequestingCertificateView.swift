//
//  RequestingCertificateView.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 18/06/2024.
//

import SwiftUI
import Factory

// MARK: - Requesting certificate view

struct RequestingCertificateView: View {

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

            case .waitingForUserToInstalCertificate:
                ProgressView {
                    Text("Continue in Debugman")
                }
                .foregroundStyle(AppDebugColors.textPrimary)
                .tint(AppDebugColors.textPrimary)

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

                ButtonFilled(text: "Request new configuration") {
                    Task {
                        do {
                            try await sessionManager.requestConfiguration()
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

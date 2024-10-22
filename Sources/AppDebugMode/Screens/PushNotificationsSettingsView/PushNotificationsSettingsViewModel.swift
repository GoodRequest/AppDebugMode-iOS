//
//  PushNotificationsSettingsViewModel.swift
//  
//
//  Created by Matus Klasovity on 31/07/2023.
//

import SwiftUI
import Combine

@MainActor
final class PushNotificationsSettingsViewModel: ObservableObject {
    
    // MARK: - State

    @Published var token: String?
    @Published var error: Error?
    @Published var hasError: Bool = false
    @Published var isShowingCopiedAlert: Bool = false
    
    // MARK: - Properties - Private
    
    private var cancellables = Set<AnyCancellable>()
    private let firebaseMessagingProvider: FirebaseMessagingProvider
    
    // MARK: - init
    
    init(pushNotificationsProvider: FirebaseMessagingProvider) {
        self.firebaseMessagingProvider = pushNotificationsProvider
    }
    
}

// MARK: - Public - Methods

extension PushNotificationsSettingsViewModel {
    
    func copyTokenToClipboard() {
        UIPasteboard.general.string = token ?? ""
        withAnimation {
            isShowingCopiedAlert = true
        }
    }

    func refreshToken(shouldRegenerate: Bool) {
        Task { 
            do {
                if shouldRegenerate {
                    try await firebaseMessagingProvider.deleteToken()
                }
                token = try await firebaseMessagingProvider.getToken()
            } catch {
                self.error = error
                hasError = true
            }
        }
    }
    
}

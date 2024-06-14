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
    private let pushNotificationsProvider: PushNotificationsProvider
    
    // MARK: - init
    
    init(pushNotificationsProvider: PushNotificationsProvider) {
        self.pushNotificationsProvider = pushNotificationsProvider
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
                    try await pushNotificationsProvider.deleteToken()
                }
                token = try await pushNotificationsProvider.getToken()
            } catch {
                self.error = error
                hasError = true
            }
        }
    }
    
}

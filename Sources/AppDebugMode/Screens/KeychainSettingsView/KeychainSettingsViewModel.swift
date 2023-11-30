//
//  KeychainSettingsViewModel.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import Foundation
import Combine

final class KeychainSettingsViewModel: ObservableObject {
    
    // MARK: - State
    
    // @Published var isError = false
    @Published var alert: Alert?
    
    @Published var keychainValues = Array(CacheProvider.shared.keychainValues)
    
    // MARK: - Enums
    
    enum Alert: Identifiable {
        
        case clearKeychainError
        case confirmation
        
        var id: String {
            UUID().uuidString
        }

    }
    
    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init

    init() {
        bindState()
    }
    
    // MARK: - Methods - Public

    func clearKeychain() {
        let isError = CacheProvider.shared.clearKeychain()
        if isError {
            alert = .clearKeychainError
        } else {
            exit(0)
        }
    }
    
    func reloadKeychain() {
        CacheProvider.shared.reload()
    }
    
}

// MARK: - Private

private extension KeychainSettingsViewModel {

    func bindState() {
        CacheProvider.shared.$keychainValues
            .map { Array($0) }
            .assign(to: \.keychainValues, on: self)
            .store(in: &cancellables)
    }

}


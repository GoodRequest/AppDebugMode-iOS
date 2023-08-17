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
    
    @Published var isError = false
    
    @Published var keychainValues = Array(CacheProvider.shared.keychainValues)
    
    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init

    init() {
        bindState()
    }
    
    // MARK: - Methods - Public

    func clearKeychain() {
        isError = CacheProvider.shared.clearKeychain()
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


//
//  UserDefaultsSettingsViewModel.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import Foundation
import Combine

final class UserDefaultsSettingsViewModel: ObservableObject {
    
    // MARK: - State
    
    @Published var userDefaultValues = Array(CacheProvider.shared.userDefaultValues).sorted(by: { $0.key < $1.key })
    
    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init

    init() {
        bindState()
    }

    // MARK: - Methods
    
    func clearUserDefaults() {
        CacheProvider.shared.clearUserDefaultsValues()
    }
    
    func reloadUserDefaults() {
        CacheProvider.shared.reload()
    }

}

// MARK: - Private

private extension UserDefaultsSettingsViewModel {

    func bindState() {
        CacheProvider.shared.$userDefaultValues
            .map { Array($0).sorted(by: { $0.key < $1.key }) }
            .assign(to: \.userDefaultValues, on: self)
            .store(in: &cancellables)
    }

}

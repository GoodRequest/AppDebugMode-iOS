//
//  File.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import Foundation

final class KeychainSettingsViewModel: ObservableObject {
    
    // MARK: - State
    
    @Published var isError = false
    
    func clearKeychain() {
        [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity].forEach {
            let status = SecItemDelete([
                kSecClass: $0,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny
            ] as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound {
                isError = true
            } else {
                exit(0)
            }
        }
    }
    
}

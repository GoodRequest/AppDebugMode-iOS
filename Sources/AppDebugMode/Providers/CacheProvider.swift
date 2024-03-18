//
//  CacheProvider.swift
//  
//
//  Created by Matus Klasovity on 31/07/2023.
//

import Foundation
import GoodPersistence
import KeychainAccess

final class CacheProvider {
    
    // MARK: - Properties - Private
    
    private var cacheManager: Any?
    
    // MARK: - Properties - Public

    @Published var userDefaultValues: [String : String] = [:]
    @Published var keychainValues: [String : String] = [:]
            
    // MARK: - Structs
    
    struct Wrapper<T: Codable>: Codable {
        
        let value: T

    }
    
    // MARK: - Shared
    
    static let shared = CacheProvider()
    
    // MARK: - Init
    
    private init() {}
    
}

// MARK: - Public

extension CacheProvider {
    
    func setup(cacheManager: Any) {
        self.cacheManager = cacheManager
        let mirror = Mirror(reflecting: cacheManager)

        mirror.children.forEach { child in
            let childMirror = Mirror(reflecting: child.value)
            
            if String(describing: child.value).contains("UserDefaultValue") {
                getUserDefaultValue(childMirror: childMirror)
            } else if String(describing: child.value).contains("KeychainValue") {
                getKeychainValue(childMirror: childMirror)
            }
        }
    }

    func reload() {
        if let cacheManager {
            userDefaultValues = [:]
            keychainValues = [:]
            setup(cacheManager: cacheManager)
        }
    }

}

// MARK: - Private - User Defaults

private extension CacheProvider {
    
    func getUserDefaultValue(childMirror: Mirror) {
        guard let key = childMirror.children.first(where: { $0.label == "key" })?.value as? String,
              let defaultValueChild = childMirror.children.first(where: { $0.label == "defaultValue" })
        else { return }
    
        let type = type(of: defaultValueChild.value)
        
        if let decodable = type as? Codable.Type {
            userDefaultValues[key] = receiveUserDefaultValueFromPropertyList(
                key: key,
                valueType: decodable.self,
                defaultValue: defaultValueChild.value
            )
        }
    }
    
    func receiveUserDefaultValueFromPropertyList<T: Codable>(key: String, valueType: T.Type, defaultValue: Any) -> String {
        if let data = UserDefaults.standard.value(forKey: key) as? T {
            return String(describing: data)
        }
        
        let defaultValueCodable = defaultValue as! Codable
        // If the data isn't of the correct type, try to decode it from the Data stored in UserDefaults.
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return formatValue(value: defaultValueCodable) }
        let value = (try? PropertyListDecoder().decode(Wrapper<T>.self, from: data)) // ?.value ?? defaultValue as? T
        
        return formatValue(value: value)
    }

}

// MARK: - Public - User Defaults

extension CacheProvider {

    func clearUserDefaultsValues() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

}

// MARK: - Private - Keychain Value

private extension CacheProvider {
    
    func getKeychainValue(childMirror: Mirror) {
        guard let key = childMirror.children.first(where: { $0.label == "key" })?.value as? String,
              let defaultValueChild = childMirror.children.first(where: { $0.label == "defaultValue" })
        else { return }
    
        let type = type(of: defaultValueChild.value)
        
        if let decodable = type as? Codable.Type {
            keychainValues[key] = receiveKeychainValueFromPropertyList(
                key: key,
                valueType: decodable.self,
                defaultValue: defaultValueChild.value
            )
        }
    }
    
    func receiveKeychainValueFromPropertyList<T: Codable>(
        key: String,
        valueType: T.Type,
        defaultValue: Any
    ) -> String {
        guard let value = try? Keychain.default.get(key) else {
            let defaultValueCodable = defaultValue as! Codable
            // Return default value if data cannot be retrieved from Keychain
            return formatValue(value: defaultValueCodable)
        }

        return formatValue(value: value)
    }

}

// MARK: - Public - Keychain Value

extension CacheProvider {
    
    /// Clear all values from Keychain
    /// - Returns: True if all values were cleared successfully, false otherwise
    func clearKeychain() -> Bool {
        var statuses: [OSStatus] = []
        [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity].forEach {
            let status = SecItemDelete([
                kSecClass: $0,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny
            ] as CFDictionary)
            statuses.append(status)
        }
        
        return !statuses.allSatisfy { $0 != errSecSuccess && $0 != errSecItemNotFound }
    }

}

// MARK: - Private

private extension CacheProvider {

    func formatValue<T: Codable>(value: T) -> String {
        do {
            let jsonEncoder = JSONEncoder()
            
            let encodedValue = try jsonEncoder.encode(value)
            let json = try JSONSerialization.jsonObject(with: encodedValue, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            return String(decoding: jsonData, as: UTF8.self)
        } catch {
            return String(describing: value)
        }
    }

}

//
//  File.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import Foundation

final class CacheSettingsViewModel: ObservableObject {
    
    // MARK: - Structs
    
    private struct Wrapper: Decodable {

        let value: String

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let stringValue = try? container.decode(String.self, forKey: .value) {
                value = stringValue
            } else if let intValue = try? container.decode(Int.self, forKey: .value) {
                value = intValue.description
            } else if let boolValue = try? container.decode(Bool.self, forKey: .value) {
                value = boolValue.description
            } else if let doubleValue = try? container.decode(Double.self, forKey: .value) {
                value = doubleValue.description
            } else if let floatValue = try? container.decode(Float.self, forKey: .value) {
                value = floatValue.description
            } else if let dateValue = try? container.decode(Date.self, forKey: .value) {
                if #available(iOS 15.0, *) {
                    value = dateValue.formatted()
                } else {
                    value = dateValue.description
                }
            } else {
                value = "Unknown"
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            
            case value
            
        }

    }
    
    // MARK: - State
    
    var cacheValues = Array(UserDefaults.standard.dictionaryRepresentation())
    

    // MARK: - Methods

    func formatValueToString(value: Any) -> String {
        if let dataValue = value as? Data {
            let decoder = PropertyListDecoder()
            let value = try? decoder.decode(Wrapper.self, from: dataValue)
            
            return value?.value ?? String(describing: dataValue)
        } else {
            return String(describing: value)
        }
    }
    
    func clearCache() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

}

//
//  UserDefaultsExtension.swift
//  
//
//  Created by Matus Klasovity on 02/07/2023.
//

import Foundation

extension UserDefaults {
    
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            // throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object? where Object: Decodable {
        guard let data = data(forKey: forKey) else { return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            // throw ObjectSavableError.unableToDecode
        }
        
        return nil
    }
    
}

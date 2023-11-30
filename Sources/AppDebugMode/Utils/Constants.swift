//
//  Constants.swift
//  
//
//  Created by Matus Klasovity on 21/09/2023.
//

import Foundation

enum Constants {

    // MARK: - iOS Version
    
    enum iOSVersion {
        
        static let iOS14: Bool = {
            guard #available(iOS 15, *) else {
                // If it's iOS 14 return true.
                return true
            }
            // If it's iOS 15 or higher, return false.
            return false
        }()
        
    }
    
}

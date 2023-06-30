//
//  NSPredicateExtension.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Foundation

extension NSPredicate {
    
    static let url = NSPredicate(format: "SELF MATCHES %@", "^https://[A-Za-z0-9.-]{2,}\\.[A-Za-z]{2,}(?:/[^\\s]*)?$")

}

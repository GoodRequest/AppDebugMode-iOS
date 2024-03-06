//
//  UINavigationBarExtension.swift
//
//
//  Created by Andrej Jasso on 06/03/2024.
//

import UIKit

extension UINavigationBar {

    func configureSolidAppearance() {
        scrollEdgeAppearance = .solidNavigationAppearance()
        compactAppearance = .solidNavigationAppearance()
        standardAppearance = .solidNavigationAppearance()
        if #available(iOS 15.0, *) {
            compactScrollEdgeAppearance = .solidNavigationAppearance()
        }
    }
    
}

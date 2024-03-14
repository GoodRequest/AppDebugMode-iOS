//
//  UINavigationBarAppearance.swift
//
//
//  Created by Andrej Jasso on 06/03/2024.
//

import UIKit

extension UINavigationBarAppearance {

    static func solidNavigationAppearance() -> UINavigationBarAppearance {

        let appearance = UINavigationBarAppearance()

        // MARK: - Standard title

        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(AppDebugColors.textPrimary),
        ]

        // MARK: - Large title

        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(AppDebugColors.textPrimary),
        ]

        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppDebugColors.backgroundPrimary)
        appearance.backgroundEffect = nil
        appearance.shadowColor = .clear

        return appearance
    }

}

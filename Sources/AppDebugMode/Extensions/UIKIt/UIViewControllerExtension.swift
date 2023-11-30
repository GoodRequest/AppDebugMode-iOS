//
//  UIViewControllerExtension.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import SwiftUI

// MARK: - View Controller Extension

extension UIViewController {

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let viewController = AppDebugModeProvider.shared.start()

            if presentedViewController == nil, view.window?.rootViewController?.presentedViewController == nil {
                present(viewController, animated: true)
            } else {
                dismiss(animated: true)
            }
        }
    }

}

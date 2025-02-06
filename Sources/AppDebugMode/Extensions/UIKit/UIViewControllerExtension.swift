//
//  UIViewControllerExtension.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import SwiftUI
import Factory

// MARK: - View Controller Extension

extension UIViewController {

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            Task { 
                guard let viewController = await Container.shared.packageManager.resolve().start() else { return }

                if presentedViewController == nil, view.window?.rootViewController?.presentedViewController == nil {
                    viewController.modalPresentationStyle = .fullScreen
                    present(viewController, animated: true)
                } else {
                    dismiss(animated: true)
                }
            }
        }
    }

}

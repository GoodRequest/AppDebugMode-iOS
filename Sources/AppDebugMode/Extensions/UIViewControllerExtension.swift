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
            let appDebugView = UIHostingController(
                rootView: AppDebugView(serversCollections: AppDebugModeProvider.shared.serversCollections)
            )
            present(appDebugView, animated: true)
        }
    }

}

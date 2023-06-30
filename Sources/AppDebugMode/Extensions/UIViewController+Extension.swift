//
//  UIViewController+Extension.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import SwiftUI

// MARK: - View Controller Extension

extension UIViewController {

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && AppDebugModeProvider.shared.isAvailable {
            let appDebugView = UIHostingController(
                rootView: AppDebugView(servers: AppDebugModeProvider.shared.servers)
            )
            present(appDebugView, animated: true)
        }
    }

}

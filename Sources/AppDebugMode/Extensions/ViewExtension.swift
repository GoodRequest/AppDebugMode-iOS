//
//  ViewExtension.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

// MARK: - Keyboard

extension View {

    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func dismissKeyboardOnDrag() -> some View {
        if #available(iOS 16, *) {
            return self
                .scrollDismissesKeyboard(.immediately)
        } else {
            return onAppear {
                UIScrollView.appearance().keyboardDismissMode = .onDrag
            }
            .onDisappear {
                UIScrollView.appearance().keyboardDismissMode = .none
            }
        }
    }

}

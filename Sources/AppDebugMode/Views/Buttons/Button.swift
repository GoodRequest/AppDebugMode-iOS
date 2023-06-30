//
//  Button.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import SwiftUI

struct PrimaryButton: View {
    
    // MARK: - Properties
    
    let text: String
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        if #available(iOS 15, *) {
            Button {
                action()
            } label: {
                Text(text)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        } else {
            Button(text, action: action)
        }
    }
    
}

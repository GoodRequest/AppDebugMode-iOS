//
//  Button.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import SwiftUI

struct PrimaryButton: View {
    
    enum ButtonStyle {
        
        case primary
        case danger
        
        var tint: Color {
            switch self {
            case .primary:
                return .blue
                
            case .danger:
                return .red
            }
        }
        
    }
    
    // MARK: - Properties
    
    let text: String
    let action: () -> Void
    let style: ButtonStyle
    
    // MARK: - Init
    
    init(text: String, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.style = style
    }
    
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
            .tint(style.tint)
        } else {
            Button(text, action: action)
                .background(style.tint)
        }
    }
    
}

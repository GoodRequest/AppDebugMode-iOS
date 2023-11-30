//
//  ButtonFilled.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import SwiftUI

struct ButtonFilled: View {
    
    enum ButtonStyle {
        
        case primary
        case secondary
        case danger
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return Color(hex: "#111117")
                
            case .secondary:
                return Color(hex: "#F6F7FB")
                
            case .danger:
                return .white
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return AppDebugColors.primary
                
            case .secondary:
                return AppDebugColors.secondary
                
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
        Button {
            action()
        } label: {
            Text(text)
                .foregroundColor(style.foregroundColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .background(style.backgroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(.borderless)
    }
    
}

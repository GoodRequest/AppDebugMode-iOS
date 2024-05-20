//
//  ButtonControlStyle.swift
//  
//
//  Created by Matus Klasovity on 20/05/2024.
//

import SwiftUI

struct ButtonControlStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(configuration.isPressed ? AppDebugColors.primary.opacity(0.5) : AppDebugColors.primary)
            .cornerRadius(8)
            .foregroundColor(AppDebugColors.black)
    }

}

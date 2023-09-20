//
//  Glass.swift
//  
//
//  Created by Matus Klasovity on 20/09/2023.
//

import SwiftUI

struct Glass: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        return
    }

}

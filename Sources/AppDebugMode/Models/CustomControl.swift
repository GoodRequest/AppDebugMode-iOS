//
//  CustomControl.swift
//
//
//  Created by Matus Klasovity on 20/05/2024.
//

import SwiftUI

public enum CustomControl {

    case button(text: String, action: () -> Void)
    case toggle(title: String, isOn: Binding<Bool>)

}

//
//  ViewControllerKey.swift
//
//
//  Created by Sebastian Mraz on 04/03/2024.
//

import SwiftUI

class HostingControllerWeakHolder {

    weak var controller: UIViewController?

    init(controller: UIViewController? = nil) {
        self.controller = controller
    }

}

struct ViewControllerKey: EnvironmentKey {

    static var defaultValue: HostingControllerWeakHolder? { nil }

}

extension EnvironmentValues {

    var hostingControllerHolder: HostingControllerWeakHolder? {
        get { return self[ViewControllerKey.self] }
        set { self[ViewControllerKey.self] = newValue }
    }

}

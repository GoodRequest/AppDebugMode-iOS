//
//  InterceptorWindowPresenter.swift
//  AppDebugModeInterceptable-iOS
//
//  Created by Filip Šašala on 22/02/2024.
//
#if canImport(GoodNetworking_Shared)

import UIKit

final class InterceptorWindow: UIWindow {

    static var interceptorBounds: CGRect = .zero

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        InterceptorWindow.interceptorBounds.contains(point) ? super.hitTest(point, with: event) : nil
    }

}

enum InterceptorWindowPresenter {

    private static var presentedWindow: InterceptorWindow?

    static func present(_ controller: UIViewController, over rootWindow: UIWindow) {
        let newWindow = InterceptorWindow(frame: rootWindow.frame)
        newWindow.windowLevel = UIWindow.Level(rootWindow.windowLevel.rawValue + 1)
        newWindow.rootViewController = controller
        newWindow.overrideUserInterfaceStyle = rootWindow.overrideUserInterfaceStyle

        controller.view.backgroundColor = .clear
        controller.modalPresentationStyle = .fullScreen

        presentedWindow = newWindow
        newWindow.makeKeyAndVisible()
    }

    static func dismiss(rootWindow: UIWindow) {
        guard let presentedWindow else { return }
        rootWindow.makeKeyAndVisible()

        presentedWindow.rootViewController = nil
        self.presentedWindow = nil
    }

}
#endif

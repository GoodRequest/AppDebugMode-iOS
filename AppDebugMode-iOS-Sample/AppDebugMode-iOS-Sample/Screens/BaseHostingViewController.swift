//
//  BaseHostingViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Andrej Jasso on 12/10/2024.
//

import SwiftUI
import Combine

extension View {

    func eraseToUIViewController() -> BaseHostingController {
        BaseHostingController(contentView: self)
    }

}

final class BaseHostingController: UIHostingController<AnyView> {

    init<Content: View>(
        contentView: Content
    ) {
        let view = contentView

        super.init(rootView: AnyView(view))
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension BaseHostingController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}

//
//  BaseHostingController.swift
//
//
//  Created by Sebastian Mraz on 04/03/2024.
//

import SwiftUI

extension View {
    
    func eraseToUIViewController() -> BaseHostingController {
        BaseHostingController(contentView: self)
    }
    
}

class BaseHostingController: UIHostingController<AnyView> {

    // MARK: - Properties

    private let viewName: String

    init<Content: View>(
        contentView: Content
    ) {
        let holder = HostingControllerWeakHolder()
        let view = contentView
            .environment(\.hostingControllerHolder, holder)

        self.viewName = String(describing: Content.self)
        super.init(rootView: AnyView(view))
        holder.controller = self
    }

    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(cgColor: AppDebugColors.primary.cgColor!)
        navigationItem.backButtonDisplayMode = .minimal
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func isTypeOf<T: View>(_ type: T.Type) -> Bool {
        return viewName == String(describing: type)
    }

}

extension BaseHostingController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}

// The Swift Programming Language
// https://docs.swift.org/swift-book

#if canImport(GoodNetworking_Shared)

import Alamofire
import SwiftUI

internal var interceptorEnabled = true
internal var interceptorAutocontinueDelay = TimeInterval(5)

public func setupInterceptor() {
    if #available(iOS 17.0, *) {
        guard let window = UIApplication.shared.delegate?.window,
              let window = window
        else { return print("⚠️ [AppDebugModeInterceptable-iOS] Something went wrong") }

        InterceptorWindowPresenter.present(
            UIHostingController(rootView: NetworkInterceptorView(
                viewModel: NetworkInterceptorViewModel()
            )),
            over: window
        )

        print("✅ [AppDebugModeInterceptable-iOS] AppDebugModeInterceptable installed")
    } else {
        print("❌ [AppDebugModeInterceptable-iOS] AppDebugModeInterceptable not available")
    }
}

@available(iOS 17.0, *)
private var _interceptionProvider: InterceptionProvider = { InterceptionProvider() }()

@available(iOS 17.0, *)
public func withInterceptionProvider<Result>(execute: (InterceptionProvider) async -> (Result)) async -> Result {
    await execute(_interceptionProvider)
}
#endif

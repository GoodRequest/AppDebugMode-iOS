//
//  InterceptorSettings.swift
//  AppDebugModeInterceptable-iOS
//
//  Created by Filip Šašala on 26/02/2024.
//

#if canImport(GoodNetworking_Shared)
import SwiftUI

// MARK: - View

public struct InterceptorSettings: View {

    public init() {}

    public var body: some View {
        Form {
            Toggle("Interceptor enabled", isOn: Binding(
                get: { interceptorEnabled },
                set: { interceptorEnabled = $0 }
            ))

            Stepper("Delay (seconds)", value: Binding(
                get: { interceptorAutocontinueDelay },
                set: { interceptorAutocontinueDelay = TimeInterval($0) }
            ), in: 1...100)
        }
    }

}

// MARK: - Previews

#Preview {
    InterceptorSettings()
}
#endif

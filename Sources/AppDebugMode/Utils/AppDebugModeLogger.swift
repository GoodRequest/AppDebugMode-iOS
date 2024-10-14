//
//  AppDebugModeLogger.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 27/09/2024.
//

import GoodLogger
import OSLog
import SwiftUI
import Factory

public struct AppDebugModeLogger: GoodLogger {

    // MARK: - Cached

    @AppStorage("capturedOutput", store: UserDefaults(suiteName: Constants.suiteName))
    var capturedOutput: [Log] = []

    public init() {}
    
    nonisolated public func log(level: OSLogType, message: String, privacy: PrivacyType) {
        capturedOutput.append(Log(message: message))
        sendToAllPeers(message: message)
    }

    func sendToAllPeers(message: String) {
#warning("Crashing the app todo: Fix")
        Task { @MainActor in
            do {
                try Container.shared.sessionManager.resolve().send(message)
            } catch {
                print("Error sending message: \(error)")
            }
        }
    }

}

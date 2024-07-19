//
//  CloudPushNotificationsViewModel.swift
//
//
//  Created by Sebastian Mraz on 19/07/2024.
//

import Foundation

enum CloudPushNotificationsValidationError: Error, Identifiable {

    case portIsNotANumber

    var id: String {
        self.localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .portIsNotANumber:
            return "Port must be a number"
        }
    }

}

final class CloudPushNotificationsViewModel: ObservableObject {

    @Published var certificate: String = ""
    @Published var certificatePassword: String = ""
    
    @Published var pushTitle: String = ""
    @Published var pushBody: String = ""

    @Published var deviceToken: String = ""
    @Published var appId: String = ""

    @Published var validationError: CloudPushNotificationsValidationError?

}

extension CloudPushNotificationsViewModel {
    
    func saveProxySettings() {
//        guard let port = Int(proxyPort) else {
//            validationError = .portIsNotANumber
//
//            return
//        }
//        ProxySettingsProvider.shared.updateProxySettings(ipAddress: proxyIpAdress, port: port)
    }

}


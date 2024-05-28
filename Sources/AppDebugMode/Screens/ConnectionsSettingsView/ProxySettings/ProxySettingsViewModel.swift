//
//  ProxySettingsViewModel.swift
//
//
//  Created by Matus Klasovity on 28/05/2024.
//

import Foundation

enum ProxySettingsValidationError: Error, Identifiable {

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

final class ProxySettingsViewModel: ObservableObject {

    @Published var proxyIpAdress: String = ProxySettingsProvider.shared.proxyIpAdress
    @Published var proxyPort: String = String(ProxySettingsProvider.shared.proxyPort)
    @Published var validationError: ProxySettingsValidationError?

}

extension ProxySettingsViewModel {

    func saveProxySettings() {
        guard let port = Int(proxyPort) else {
            validationError = .portIsNotANumber

            return
        }
        ProxySettingsProvider.shared.updateProxySettings(ipAddress: proxyIpAdress, port: port)
    }

}

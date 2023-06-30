//
//  ServerPickerViewModel.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import Foundation

final class ServerPickerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedServer = ApiServerProvider.shared.apiServer
    @Published var textContent = ""
    @Published var hasValidationError = false
    
    // MARK: - Methods
    
    func saveCustomURL() {
        if NSPredicate.url.evaluate(with: textContent) {
            selectedServer = ApiServer(name: "Custom", url: textContent)
        } else {
            hasValidationError = true
        }
    }
    
    func saveServerSettings() {
        ApiServerProvider.shared.changeApiServer(server: selectedServer)
        AppDebugModeProvider.shared.onServerChange?(selectedServer)
        exit(0)
    }

}

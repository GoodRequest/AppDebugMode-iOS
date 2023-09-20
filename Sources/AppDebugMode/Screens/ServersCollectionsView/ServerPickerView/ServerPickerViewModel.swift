//
//  ServerPickerViewModel.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import Foundation

final class ServerPickerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedServer: ApiServer // = ApiServerProvider.shared.apiServer
    @Published var textContent = ""
    @Published var hasValidationError = false
    
    // MARK: - Init
    
    init(selectedServer: ApiServer) {
        self.selectedServer = selectedServer
    }
    
    // MARK: - Methods
    
    func useCustomURL() {
        if NSPredicate.url.evaluate(with: textContent) {
            selectedServer = ApiServer(name: "Custom", url: textContent)
        } else {
            hasValidationError = true
        }
    }

}

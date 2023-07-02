//
//  ApiServerCollection.swift
//  
//
//  Created by Matus Klasovity on 02/07/2023.
//

import Foundation

public final class ApiServerCollection: ObservableObject {
        
    // MARK: - Properties

    let name: String
    let note: String
    let servers: [ApiServer]
    
    // MARK: - Published State
    
    @Published var selectedServer: ApiServer
    @Published var textContent = ""
    @Published var hasValidationError = false
    
    // MARK: - Init
    
    public init(name: String, note: String = "", servers: [ApiServer], defaultSelectedServer: ApiServer) {
        self.name = name
        self.note = note
        self.servers = servers
        
        if let selectedServer = try? UserDefaults.standard.getObject(forKey: name, castTo: ApiServer.self) {
            self.selectedServer = selectedServer
        } else {
            self.selectedServer = defaultSelectedServer
        }
    }
    
    
    // MARK: - Methods
    
    func useCustomURL() {
        if NSPredicate.url.evaluate(with: textContent) {
            selectedServer = ApiServer(name: "Custom", url: textContent)
        } else {
            hasValidationError = true
        }
    }
    
    func saveSelectedServer() {
        try! UserDefaults.standard.setObject(selectedServer, forKey: name)
        AppDebugModeProvider.shared.onServerChange?()
    }

}

// MARK: - Equatable

extension ApiServerCollection: Equatable {
    
    public static func == (lhs: ApiServerCollection, rhs: ApiServerCollection) -> Bool {
        lhs.name == rhs.name && lhs.servers == rhs.servers && lhs.selectedServer == rhs.selectedServer
    }
    
}

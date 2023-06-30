//
//  ServersCollectionsViewModel.swift
//  
//
//  Created by Matus Klasovity on 02/07/2023.
//

import Foundation

final class ServersCollectionsViewModel: ObservableObject {
    
    // MARK: - State
    
    let serversCollections: [ApiServerCollection]
    
    // MARK: - Init
    
    init(serversCollections: [ApiServerCollection]) {
        self.serversCollections = serversCollections
    }
    
    // MARK: - Methods
    
    func saveServerSettings() {
        serversCollections.forEach {
            $0.saveSelectedServer()
        }
        exit(0)
    }
    
}

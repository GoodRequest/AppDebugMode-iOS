//
//  AppDebugModeProvider.swift
//  
//
//  Created by Matus Klasovity on 27/06/2023.
//

import Combine

public final class AppDebugModeProvider {
    
    // MARK: - Shared
    
    public static let shared = AppDebugModeProvider()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Properties
    
    var servers: [ApiServer] = []
    var serversCollections: [ApiServerCollection] = []
    var onServerChange: (() -> Void)?
    
    // MARK: - Methods
    
    public var selectedTestingUser: TestingUser? {
        TestingUsersProvider.shared.selectedTestingUser
    }
    
    public var selectedTestingUserPublisher = TestingUsersProvider.shared.selectedTestingUserPublisher
    
    
    public func setup(serversCollections: [ApiServerCollection], onServerChange: (() -> Void)? = nil, cacheManager: Any? = nil) {
        self.serversCollections = serversCollections
        self.onServerChange = onServerChange
        
        if let cacheManager {
            CacheProvider.shared.setup(cacheManager: cacheManager)
        }
    }
    
    public func getSelectedServer(for serverCollection: ApiServerCollection) -> ApiServer {
        serversCollections.first { $0 == serverCollection }!.selectedServer
    }
    
}

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
    var isAvailable = false
    var onServerChange: ((ApiServer) -> Void)?
    
    // MARK: - Methods
    
    public var selectedServer: ApiServer {
        ApiServerProvider.shared.apiServer
    }
    
    public var selectedTestingUser: TestingUser? {
        TestingUsersProvider.shared.selectedTestingUser
    }
    
    public var selectedTestingUserPublisher = TestingUsersProvider.shared.selectedTestingUserPublisher
    
    public func setup(defaultServer: ApiServer, availableServers: [ApiServer], onServerChange: ((ApiServer) -> Void)? = nil) {
        ApiServerProvider.shared.setDefaultValue(server: defaultServer)
        servers = availableServers
        isAvailable = true
        self.onServerChange = onServerChange
    }
    
}

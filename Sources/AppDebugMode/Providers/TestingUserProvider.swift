//
//  TestingUsersProvider.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import Combine
import GoodPersistence

struct TestingUsersProvider {
    
    // MARK: - Cache
    
    @UserDefaultValue("testingUsers", defaultValue: [])
    private(set) var testingUsers: [TestingUser]

    @UserDefaultValue("selectedTestingUser", defaultValue: nil)
    private(set) var selectedTestingUser: TestingUser?

    // MARK: - Shared
    
    static var shared: Self = .init()

    // MARK: - Methods
    
    func setTestingUsers(testingUsers: [TestingUser]) {
        self.testingUsers = testingUsers
    }

    func setSelectedTestingUser(testingUser: TestingUser) {
        self.selectedTestingUser = testingUser
    }

    // MARK: - Combine

    public lazy var selectedTestingUserPublisher = _selectedTestingUser.publisher.eraseToAnyPublisher()

}

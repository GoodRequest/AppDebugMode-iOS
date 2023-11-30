//
//  UserProfilesProvider.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import Combine
import GoodPersistence

struct UserProfilesProvider {
    
    // MARK: - Cache
    
    @UserDefaultValue("testingUsers", defaultValue: [])
    private(set) var userProfiles: [UserProfile]

    @UserDefaultValue("selectedTestingUser", defaultValue: nil)
    private(set) var selectedUserProfile: UserProfile?

    // MARK: - Shared
    
    static var shared: Self = .init()

    // MARK: - Methods
    
    func setUserProfiles(userProfiles: [UserProfile]) {
        self.userProfiles = userProfiles
    }

    func setSelectedUserProfile(userProfile: UserProfile) {
        self.selectedUserProfile = userProfile
    }

    // MARK: - Combine

    public lazy var selectedUserProfilePublisher = _selectedUserProfile.publisher.eraseToAnyPublisher()

}

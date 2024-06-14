//
//  UserProfilesProvider.swift
//  AppDebugMode-iOS
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

public struct UserProfilesProvider {
    
    // MARK: - Cache
    
    @AppStorage("testingUsers", store: UserDefaults(suiteName: Constants.suiteName))
    private(set) var userProfiles: [UserProfile] = []

    @AppStorage("selectedUserUser", store: UserDefaults(suiteName: Constants.suiteName))
    private(set) var selectedUserProfile: UserProfile?

}

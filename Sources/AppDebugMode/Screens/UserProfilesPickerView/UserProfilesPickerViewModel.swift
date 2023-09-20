//
//  UserProfilesPickerViewModel.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

final class UserProfilesPickerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isFileImporterPresented = false
    @Published var userProfiles = UserProfilesProvider.shared.userProfiles
    @Published var selectedUserProfile = UserProfilesProvider.shared.selectedUserProfile
    @Published var hasValidationError = false
    @Published var isShowingCopiedAlert = false
    @Published var hintModalIsPresented = false
    
    // MARK: - Constants
    
    let jsonExample = """
                [
                    {
                        "name": "user1",
                        "password": "password1"
                    },
                    {
                        "name": "user2",
                        "password": "password2"
                    }
                ]
                """
    
    // MARK: - Methods
    
    func setSelectedUserProfile(userProfile: UserProfile) {
        selectedUserProfile = userProfile
        UserProfilesProvider.shared.setSelectedUserProfile(userProfile: userProfile)
    }

    func copyExampleJson() {
        UIPasteboard.general.string = jsonExample
        withAnimation {
            isShowingCopiedAlert = true
        }
    }
    
    func loadTestingProfileFromFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)

                userProfiles = try decoder.decode([UserProfile].self, from: data)
                UserProfilesProvider.shared.setUserProfiles(userProfiles: userProfiles)
            } catch {
                hasValidationError = true
            }
        case .failure:
            hasValidationError = true
        }
    }
    
}

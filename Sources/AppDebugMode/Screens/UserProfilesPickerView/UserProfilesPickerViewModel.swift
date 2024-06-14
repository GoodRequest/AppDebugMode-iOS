//
//  UserProfilesPickerViewModel.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

final class UserProfilesPickerViewModel: ObservableObject {

    // MARK: - Cached

    @AppStorage("testingUsers", store: UserDefaults(suiteName: Constants.suiteName))
    private(set) var userProfiles: [UserProfile] = []

    // MARK: - Properties
    
    @Published var isFileImporterPresented = false
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

    init() {}

    // MARK: - Methods

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
            } catch {
                hasValidationError = true
            }
        case .failure:
            hasValidationError = true
        }
    }
    
}

//
//  TestingUserPickerViewModel.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import Foundation

final class TestingUserPickerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isFileImporterPresented = false
    @Published var testingUsers = TestingUsersProvider.shared.testingUsers
    @Published var selectedTestingUser = TestingUsersProvider.shared.selectedTestingUser
    @Published var hasValidationError = false
    
    // MARK: - Methods
    
    func setSelectedTestingUserProfile(testingUser: TestingUser) {
        selectedTestingUser = testingUser
        TestingUsersProvider.shared.setSelectedTestingUser(testingUser: testingUser)
    }
    
    func loadTestingProfileFromFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)

                testingUsers = try decoder.decode([TestingUser].self, from: data)
                TestingUsersProvider.shared.setTestingUsers(testingUsers: testingUsers)
            } catch {
                hasValidationError = true
            }
        case .failure:
            hasValidationError = true
        }
    }
    
}

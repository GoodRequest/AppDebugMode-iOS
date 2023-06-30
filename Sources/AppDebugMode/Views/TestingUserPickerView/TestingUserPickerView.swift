//
//  TestingUserPickerView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

struct TestingUserPickerView: View {

    // MARK: - State

    @ObservedObject private var viewModel = TestingUserPickerViewModel()

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.testingUsers.isEmpty {
                emptyView()
            } else {
                Group {
                    userProfilesList()
                    PrimaryButton(text: "Import new testing user profiles") {
                        viewModel.isFileImporterPresented = true
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.hasValidationError) {
            Alert(
                title: Text("Parsing error"),
                message: Text("Please check data format")
            )
        }
        .fileImporter(
            isPresented: $viewModel.isFileImporterPresented,
            allowedContentTypes: [.json],
            onCompletion: { viewModel.loadTestingProfileFromFile(result: $0) }
        )
    }

}

// MARK: - Components

private extension TestingUserPickerView {

    func emptyView() -> some View {
        VStack(alignment: .center) {
            Text("No user profiles were found.")
                .multilineTextAlignment(.center)
                .font(.title3)

            Button("Import them!") {
                viewModel.isFileImporterPresented = true
            }
        }.frame(maxWidth: .infinity)
    }

    func userProfilesList() -> some View {
        ForEach(viewModel.testingUsers, id: \.name) { testingUser in
            Button {
                viewModel.setSelectedTestingUserProfile(testingUser: testingUser)
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name: \(testingUser.name)")
                        Text("Password: \(testingUser.password)")
                    }

                    Spacer()

                    if testingUser == viewModel.selectedTestingUser {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(SwiftUI.Color.green)
                    }
                }
            }.buttonStyle(.plain)
        }
    }

}

// MARK: - Previews

struct TestingUserPickerView_Previews: PreviewProvider {

    static var previews: some View {
        TestingUserPickerView()
    }

}

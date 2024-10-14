//
//  UserProfilesPickerView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI
import Factory

struct UserProfilesPickerView: View {


    // MARK: - Cached

    @AppStorage("testingUsers", store: UserDefaults(suiteName: Constants.suiteName))
    private(set) var userProfiles: [UserProfile] = []

    @AppStorage("selectedUserUser", store: UserDefaults(suiteName: Constants.suiteName))
    private(set) var selectedUserProfile: UserProfile?

    // MARK: - Observed

    @ObservedObject private var viewModel: UserProfilesPickerViewModel

    // MARK: - Body

    init(viewModel: UserProfilesPickerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content()
            .navigationTitle("User profiles picker")
            .toolbar {
                hintNavigationBarItem()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppDebugColors.backgroundPrimary.edgesIgnoringSafeArea(.bottom))
            .alert(isPresented: $viewModel.hasValidationError) {
                parsingErrorAlert()
            }
            .copiedAlert(isPresented: $viewModel.isShowingCopiedAlert)
            .swiftUIDocumentPicker(
                isPresented: $viewModel.isFileImporterPresented,
                allowedContentTypes: [.json],
                onCompletion: { viewModel.loadTestingProfileFromFile(result: $0) }
            )
    }

}

// MARK: - Components

private extension UserProfilesPickerView {
    
    func content() -> some View {
        ZStack {
            if #available(iOS 15, *) {
                userProfilesList()
                    .safeAreaInset(edge: .bottom) {
                        importUserProfilesFooter()
                    }
            } else {
                ZStack(alignment: .bottom) {
                    userProfilesList()
                    importUserProfilesFooter()
                }
            }

            hintModal()
        }
    }
    
    func exampleJsonView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(AppDebugColors.textPrimary)
                
                Text("You can import user profiles from a JSON file.")
                    .bold()
                    .foregroundColor(AppDebugColors.textPrimary)
            }
            
            Button {
                viewModel.copyExampleJson()
            } label: {
                ZStack(alignment: .topTrailing) {
                    Text(viewModel.jsonExample)
                        .padding(8)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppDebugColors.backgroundSecondary)
                        .cornerRadius(8)
                        .foregroundColor(AppDebugColors.textPrimary)
                    
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(AppDebugColors.primary)
                        .padding(8)
                }
            }
        }
        .padding(16)
        .background(AppDebugColors.secondary)
        .cornerRadius(8)
    }
    
    // MARK: - Empty View
    
    func emptyView() -> some View {
        VStack(alignment: .center) {
            Text("No user profiles were found!")
                .font(.title)
                .foregroundColor(AppDebugColors.textPrimary)
                .multilineTextAlignment(.center)
            
            exampleJsonView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
    }
    
    // MARK: - List
    
    @ViewBuilder
    func userProfilesList() -> some View {
        if viewModel.userProfiles.isEmpty {
            emptyView()
        } else {
            List {
                Section {
                    ForEach(viewModel.userProfiles, id: \.name) { userProfile in
                        userProfileItemView(userProfile: userProfile)
                            .listRowBackground(AppDebugColors.backgroundSecondary)
                    }
                } header: {
                    Text("User profiles")
                        .foregroundColor(AppDebugColors.textSecondary)
                }
            }
            .listStyle(.insetGrouped)
            .listContentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0), for: .insetGrouped) 
            .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
        }
    }
    
    func userProfileItemView(userProfile: UserProfile) -> some View {
        Button {
            self.selectedUserProfile = userProfile
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("Name: \(userProfile.name)")
                        .foregroundColor(AppDebugColors.textPrimary)

                    Text("Password: \(userProfile.password)")
                        .foregroundColor(AppDebugColors.textPrimary)
                }

                Spacer()

                if userProfile == selectedUserProfile {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(SwiftUI.Color.green)
                }
            }
        }
        .buttonStyle(.borderless)
    }
    
    // MARK: - Footer
    
    func importUserProfilesFooter() -> some View {
        ButtonFilled(text: "Import profiles") {
            viewModel.isFileImporterPresented = true
        }
        .padding(16)
        .background(Glass().ignoresSafeArea(edges: .bottom))
    }
    
    // MARK: - Navigation items
    
    @ToolbarContentBuilder
    func hintNavigationBarItem() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    viewModel.hintModalIsPresented = true
                }
            } label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(AppDebugColors.primary)
            }
        }
    }
    
    // MARK: - Modals
    
    func hintModal() -> some View {
        ZStack {
            if viewModel.hintModalIsPresented {
                exampleJsonView()
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Glass().edgesIgnoringSafeArea(.all))
                    .onTapGesture {
                        withAnimation {
                            viewModel.hintModalIsPresented = false
                        }
                    }
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Alerts
    
    func parsingErrorAlert() -> Alert {
        Alert(
            title: Text("Parsing error"),
            message: Text("Please check data format")
        )
    }

}

#Preview {

    UserProfilesPickerView(viewModel: .init())

}

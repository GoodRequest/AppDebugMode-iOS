//
//  ProfileView.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import SwiftUI

struct ProfileView: View {

    // MARK: - AppStorage

    @AppStorage("fullName") var fullName: String = ""
    @AppStorage("gender") var gender: Int = 0
    @AppStorage("favoriteColor") var favoriteColor: String = "Red"

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Enter your full name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .overlay(
                        VStack {
                            Text("Full name")
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.top, -30)
                                .padding(.bottom, 10)
                        },
                        alignment: .leading
                    )

                Picker("Gender", selection: $gender) {
                    Text("Male").tag(0)
                    Text("Female").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                HStack {
                    Text("Favorite Color(Preset):")
                    Text(favoriteColor)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("User Profile Mode")
        }
        .padding()
    }

}

#Preview {
    ProfileView()
}

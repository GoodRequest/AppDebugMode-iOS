//
//  ProfileView.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import SwiftUI

final class HostingProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = ProfileView()
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)

        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

}

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

//
//  LoginView.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import SwiftUI
import Combine
#if DEBUG
import AppDebugMode
#endif

final class HostingLoginView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = LoginView()
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

struct LoginView: View {

    #if DEBUG
    @AppStorage("selectedUserUser", store: UserDefaults(suiteName: AppDebugMode.Constants.suiteName))
    private(set) var selectedUserProfile: UserProfile?
    #endif
    
    // MARK: - State
    @State private var loginName: String = ""
    @State private var password: String = ""

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                // Login Name Input
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.caption)
                    TextField("Enter your login name", text: $loginName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding(.vertical, 5)
                }

                // Password Input
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.caption)
                    SecureField("Enter your login password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                }

                Spacer()
            }
            .padding(.horizontal, 32)
            .navigationTitle("User Login Mode")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear() {
            #if DEBUG
            loginName = selectedUserProfile?.name ?? "No selected profile to use"
            password = selectedUserProfile?.password  ?? "No selected profile to use"
            #else
            loginName = "In DEV build value will be prefilled"
            password = "In DEV build value will be prefilled"
            #endif
        }
    }

}

#Preview {
    LoginView()
}

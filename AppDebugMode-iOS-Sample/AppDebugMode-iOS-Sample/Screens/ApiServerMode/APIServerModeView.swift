//
//  APIServerModeView.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import SwiftUI

final class HostingApiServerModeView: UIViewController {

    // MARK: - Properties

    let viewModel: APIServerModeViewModel

    // MARK: - Initializer

    @MainActor
    init(viewModel: APIServerModeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = APIServerModeView(viewModel: viewModel)
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

struct APIServerModeView: View {

    // MARK: - State

    @State private var selectedServerName: String = ""
    @State private var selectedServerURL: String = ""
    @State private var simpleResponse: String = "No response processed"
    @State private var largeResponse: String = "No response processed"
    @State private var isFetchingSimpleResponse: Bool = false
    @State private var isFetchingLargeObject: Bool = false


    init(viewModel: APIServerModeViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject var viewModel: APIServerModeViewModel

    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Server Label
                    Text("\(viewModel.selectedServerName): \(viewModel.selectedServerURL)")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    // Simple Response Label
                    Text(simpleResponse)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    // Large Object Response Label
                    Text(largeResponse)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    // Fetch Simple Response Button
                    Button(action: fetchSimpleResponse) {
                        Text(isFetchingSimpleResponse ? "Fetching..." : "Fetch Simple Response")
                    }
                    .buttonStyle(FetchButtonStyle(isLoading: isFetchingSimpleResponse))

                    // Fetch Large Object Button
                    Button(action: fetchLargeObject) {
                        Text(isFetchingLargeObject ? "Fetching..." : "Fetch Large Object")
                    }
                    .buttonStyle(FetchButtonStyle(isLoading: isFetchingLargeObject))
                }
                .padding(.horizontal, 32)
            }
            .navigationTitle("API Server Mode")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // Initial setup
                self.selectedServerName = viewModel.selectedServerName
                self.selectedServerURL = viewModel.selectedServerURL
            }
        }
    }

    // MARK: - Action Methods

    private func fetchSimpleResponse() {
        isFetchingSimpleResponse = true
        Task {
            await viewModel.fetchSimpleResponse()
            handleSimpleResponse()
            isFetchingSimpleResponse = false
        }
    }

    private func fetchLargeObject() {
        isFetchingLargeObject = true
        Task {
            await viewModel.fetchLargeObject()
            handleLargeResponse()
            isFetchingLargeObject = false
        }
    }

    // MARK: - Handle Responses

    private func handleSimpleResponse() {
        switch viewModel.carResult {
        case .idle:
            simpleResponse = "No response processed"
        case .loading:
            simpleResponse = "Loading..."
        case .success(let carResponse):
            if let data = try? JSONEncoder().encode(carResponse) {
                simpleResponse = String(data: data, encoding: .utf8) ?? "Invalid response"
            }
        case .error(let error):
            simpleResponse = error.localizedDescription
        }
    }

    private func handleLargeResponse() {
        switch viewModel.largeResult {
        case .idle:
            largeResponse = "No response processed"
        case .loading:
            largeResponse = "Loading..."
        case .success(let largeResponseData):
            if let data = try? JSONEncoder().encode(largeResponseData) {
                largeResponse = String(data: data, encoding: .utf8)?.prefix(5_000).appending("...") ?? "Invalid response"
            }
        case .error(let error):
            largeResponse = error.localizedDescription
        }
    }
}

struct FetchButtonStyle: ButtonStyle {
    var isLoading: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isLoading ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut, value: isLoading)
    }
}

//
//  APIServerModeView.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import SwiftUI

struct ApiServerModeView: View {

    // MARK: - State

    @State private var selectedServerName: String = ""
    @State private var selectedServerURL: String = ""
    @State private var simpleResponse: String = "No response processed"
    @State private var largeResponse: String = "No response processed"
    @State private var isFetchingSimpleResponse: Bool = false
    @State private var isFetchingLargeObject: Bool = false


    init(viewModel: ApiServerModeViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject var viewModel: ApiServerModeViewModel

    // MARK: - Body
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    HStack {
                        Button(action: fetchSimpleResponse) {
                            Text(isFetchingSimpleResponse ? "Fetching..." : "Fetch Simple Response")
                        }
                        .buttonStyle(FetchButtonStyle(isLoading: isFetchingSimpleResponse))

                        Button(action: fetchLargeObject) {
                            Text(isFetchingLargeObject ? "Fetching..." : "Fetch Large Object")
                        }
                        .buttonStyle(FetchButtonStyle(isLoading: isFetchingLargeObject))
                    }

                    Group {
                        Text("\(viewModel.selectedServerName): \(viewModel.selectedServerURL)")

                        Text(simpleResponse)

                        Text(largeResponse)

                    }
                    .frame(width: proxy.size.width)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                    .padding()
                }
            }
        }
        .navigationTitle("API Server Mode")
        .onAppear {
            self.selectedServerName = viewModel.selectedServerName
            self.selectedServerURL = viewModel.selectedServerURL
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

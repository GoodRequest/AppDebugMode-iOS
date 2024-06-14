//
//  ServerPickerView.swift
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI
import SwiftUIIntrospect
import Factory

struct ServerPickerView: View {

    // MARK: - Properties

    private let serverSelector: DebugSelectableServerProvider

    // MARK: - State

    @State private var customURL = ""
    @State private var customName = ""
    @State private var selectedServer: ApiServer?
    @State private var failureAddingServer = false
    @State private var serverCollection: ApiServerCollection?

    // MARK: - Initializer

    init(serverSelector: DebugSelectableServerProvider) {
        self.serverSelector = serverSelector
    }

    // MARK: - Body

    var body: some View {
        VStack {
            if let serverCollection, let selectedServer {
                currentlyPickedServerView(
                    selectedServer: selectedServer,
                    serverCollection: serverCollection
                )
            }
            if let serverCollection {
                serverPicker(serverCollection: serverCollection)
            }
            serverInputView()
        }
        .alert(isPresented: $failureAddingServer) {
            Alert(
                title: Text("Validation error"),
                message: Text("Please check url format")
            )
        }
        .onChange(of: selectedServer) { newServer in
            hideKeyboard()
            Task {
                if let newServer {
                    await serverSelector.setSelectedServer(newServer)
                }
            }
        }
        .task {
            await updateServerCollection()
            selectedServer = await serverSelector.getSelectedServer()
        }
    }
}
// MARK: - Components

private extension ServerPickerView {

    func currentlyPickedServerView(selectedServer: ApiServer, serverCollection: ApiServerCollection) -> some View {
        VStack(spacing: 4) {
            Text(serverCollection.name)
                .bold()
                .font(.title2)
                .foregroundColor(AppDebugColors.primary)

            Text("Currently picked server:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppDebugColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

            Text(selectedServer.name)
                .bold()
                .foregroundColor(AppDebugColors.primary)

            Text(selectedServer.url)
                .foregroundColor(AppDebugColors.textPrimary)

        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 16)
    }

    func serverPicker(serverCollection: ApiServerCollection) -> some View {
        VStack {
            Text("Select server:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppDebugColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

            if serverCollection.servers.count > 5 {
                Picker("Please select a server", selection: $selectedServer) {
                    ForEach(serverCollection.servers, id: \.self) { server in
                        HStack {
                            Text(server.name)
                            Text(server.url)
                        }
                        .tag(server as ApiServer?)

                    }
                }
                .pickerStyle(.menu)
                .tint(AppDebugColors.primary)
                .foregroundColor(AppDebugColors.textPrimary)
            } else {
                Picker("Please select a server", selection: $selectedServer) {
                    ForEach(serverCollection.servers, id: \.self) { server in
                        Text(server.name)
                            .tag(server as ApiServer?)
                    }
                }
                .pickerStyle(.segmented)
                .introspect(.picker(style: .segmented), on: .iOS(.v14, .v15, .v16, .v17, .v18)) { segmentedControl in
                    segmentedControl.selectedSegmentTintColor = UIColor(AppDebugColors.primary)
                    segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                    segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(AppDebugColors.primary)], for: .normal)
                }

            }
        }
        .padding(.vertical, 16)
    }

    func serverInputView() -> some View {
        VStack {
            Text("Need a custom server? Add it here. I will cache it until you uninstall the app")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppDebugColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

            Text("Server Name:")
                .foregroundColor(AppDebugColors.textPrimary)

            TextField("Server Name", text: $customName)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.URL)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                )
                .foregroundColor(AppDebugColors.textPrimary)

            Text("Server URL:")
                .foregroundColor(AppDebugColors.textPrimary)

            TextField("Server URL", text: $customURL)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.URL)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                )
                .foregroundColor(AppDebugColors.textPrimary)

            ButtonFilled(text: "Add Custom URL", style: .secondary) {
                Task {
                    do {
                        try await serverSelector.addCustomServer(customServerUrlString: customURL, customName: customName, collectionName: serverCollection?.name ?? "Default Name")
                        await updateServerCollection()
                    } catch {
                        failureAddingServer = true
                    }
                }
            }

            ButtonFilled(text: "Delete Custom Servers", style: .secondary) {
                Task {
                    for customServer in await serverSelector.customServers {
                        await serverSelector.deleteCustomServer(customServer)
                    }
                    await updateServerCollection()
                }
            }

            Text("NOTE: Add URL in correct fromat, containing domain as well as directory path.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(AppDebugColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

}

private extension ServerPickerView {

    func updateServerCollection() async {
        let oldServerCollection = await serverSelector.serverCollection
        let customServers = await serverSelector.customServers
        let newServerCollection = ApiServerCollection.init(
            name: oldServerCollection.name,
            servers: oldServerCollection.servers + customServers,
            defaultServer: oldServerCollection.defaultServer
        )
        serverCollection = newServerCollection
    }

}

#Preview {

    @Injected(\.debugServerSelectors) var debugServerSelectors: [DebugSelectableServerProvider]

    ServerPickerView(serverSelector: debugServerSelectors.first!)

}

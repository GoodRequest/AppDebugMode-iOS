//
//  ServersCollectionView.swift
//
//  Created by Matus Klasovity on 02/07/2023.
//

import SwiftUI
import Factory

struct ServersCollectionsView: View {

    // MARK: - Factory

    @Injected(\.debugServerSelectors) private var serverSelectors: [DebugSelectableServerProvider]

    // MARK: - State
    
    @State private var serverCollections: [ApiServerCollection] = []

    // MARK: - Body

    var body: some View {
        Group {
            serverSettingsList()
        }
        .navigationTitle("Server collections")
        .task {
            for await server in serverSelectors.publisher.values {
                await serverCollections.append(server.serverCollection)
            }
        }
    }

}

// MARK: - Components

private extension ServersCollectionsView {

    func serverSettingsList() -> some View {
        List {
            ForEach(serverSelectors, id: \.self) { serverSelector in
                serverCollectionSection(serverSelector: serverSelector)
            }
        }
        .listStyle(.insetGrouped)
        .listContentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0), for: .insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
        .safeAreaInset(edge: .bottom) {
            footnotes()
        }
    }

    // MARK: - Server Picker List Item View

    func serverCollectionSection(serverSelector: DebugSelectableServerProvider) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 16) {
                ServerPickerView(serverSelector: serverSelector)
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        }
    }

    // MARK: - Footer

    func footnotes() -> some View {
        VStack(spacing: 10) {
            Text("App will be dynamically change the server if you create the debug server selector in the project and retain use the same object to resolved URL's in the request manager. Otherwise you need to restart the app to refresh the server.")
                .multilineTextAlignment(.center)
                .foregroundColor(AppDebugColors.textSecondary)
                .font(.caption)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Glass().edgesIgnoringSafeArea(.bottom))
    }
    
    func note(text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(AppDebugColors.textSecondary)
    }

}

#Preview {
    ServersCollectionsView()
}

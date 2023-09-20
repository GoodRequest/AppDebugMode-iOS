//
//  ServersCollectionView.swift
//  
//
//  Created by Matus Klasovity on 02/07/2023.
//

import SwiftUI

struct ServersCollectionsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ServersCollectionsViewModel
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if #available(iOS 15, *) {
                serverSettingsList()
                    .safeAreaInset(edge: .bottom) {
                        saveServerSettingsFooter()
                    }
            } else {
                ZStack(alignment: .bottom) {
                    serverSettingsList()
                    saveServerSettingsFooter()
                }
            }
        }.navigationTitle("Server collections")
    }
    
}

// MARK: - Components

private extension ServersCollectionsView {
    
    // MARK: - List
    
    func serverSettingsList() -> some View {
        List {
            ForEach(viewModel.serversCollections, id: \.name) { serverCollection in
                serverCollectionSection(serverCollection: serverCollection)
            }
        }
        .listStyle(.insetGrouped)
        .listContentInsets(UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0), for: .insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }
    
    // MARK: - Server Picker List Item View
    
    func serverCollectionSection(serverCollection: ApiServerCollection) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 16) {
                title(text: serverCollection.name)
                
                if !serverCollection.note.isEmpty {
                    note(text: serverCollection.note)
                }
                
                ServerPickerView(viewModel: serverCollection)
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        }
    }
    
    // MARK: - Footer
    
    func saveServerSettingsFooter() -> some View {
        VStack(spacing: 10) {
            ButtonFilled(text: "Save server settings") {
                viewModel.saveServerSettings()
            }

            Text("App will be terminated in the moment you save the changes due to propper change of picked server.")
                .multilineTextAlignment(.center)
                .foregroundColor(AppDebugColors.textSecondary)
                .font(.caption)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Glass().edgesIgnoringSafeArea(.bottom))
    }
    
    func title(text: String) -> some View{
        Text(text)
            .bold()
            .font(.title2)
            .foregroundColor(AppDebugColors.primary)
    }
    
    func note(text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(AppDebugColors.textSecondary)
    }

}

// MARK: - Previews

struct ServersCollectionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ServersCollectionsView(viewModel: ServersCollectionsViewModel(serversCollections: []))
    }
    
}


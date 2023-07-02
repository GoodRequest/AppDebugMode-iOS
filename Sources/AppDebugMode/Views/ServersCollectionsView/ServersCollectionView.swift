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
        VStack {
            ForEach(viewModel.serversCollections, id: \.name) { serverCollection in
                VStack(alignment: .leading, spacing: 16) {
                    title(text: serverCollection.name)
                    
                    if !serverCollection.note.isEmpty {
                        note(text: serverCollection.note)
                    }
                    
                    ServerPickerView(viewModel: serverCollection)
                }
            }
            
            VStack {
                PrimaryButton(text: "Save server settings") {
                    viewModel.saveServerSettings()
                }

                Text("App will be terminated in the moment you save the changes due to propper change of picked server.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
        }
    }
    
}

// MARK: - Components

private extension ServersCollectionsView {
    
    func title(text: String) -> some View{
        Text(text)
            .bold()
            .font(.title2)
    }
    
    func note(text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundColor(Color.gray)
    }

}

// MARK: - Previews

struct ServersCollectionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ServersCollectionsView(viewModel: ServersCollectionsViewModel(serversCollections: []))
    }
    
}


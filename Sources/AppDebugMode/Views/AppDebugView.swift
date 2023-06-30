//
//  File.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

// MARK: - App Debug View

struct AppDebugView: View {

    // MARK: - State

    @State private var showServerSettings = false
    @State private var showUserProfiles = false
    
    // MARK: - Properties
    
    public let servers: [ApiServer]
    
    // MARK: - Init
    
    public init(servers: [ApiServer]) {
        self.servers = servers
    }

    // MARK: - Body

    public var body: some View {
        List {
            serverPickerSection()
            userProfilesSection()
        }
        .listStyle(.insetGrouped)
        .dismissKeyboardOnDrag()
    }

}

// MARK: - Components

private extension AppDebugView {

    func serverPickerSection() -> some View {
        Section {
            if showServerSettings {
                ServerPickerView(servers: servers)
            }
        } header: {
            ExpandableHeaderView(title: "Server settings", isExpanded: $showServerSettings)
        }
    }

    func userProfilesSection() -> some View {
        Section {
            if showUserProfiles {
                TestingUserPickerView()
            }
        } header: {
            ExpandableHeaderView(title: "Testing User profiles", isExpanded: $showUserProfiles)
        }
    }

    struct ExpandableHeaderView: View {
        let title: String
        @Binding var isExpanded: Bool

        var body: some View {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.up")
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                }
            }
        }
    }

}

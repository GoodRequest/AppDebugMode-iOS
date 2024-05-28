//
//  ConnectionsSettingsView.swift
//
//
//  Created by Matus Klasovity on 21/05/2024.
//

import SwiftUI

struct ConnectionsSettingsView: View {

    var body: some View {
        List {
            connectedPeersSection()
            proxySettingsSection()
        }
        .navigationTitle("Connections")
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }

}

// MARK: - Components

private extension ConnectionsSettingsView {

    func connectedPeersSection() -> some View {
        Section {
            ConnectedPeersView()
                .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Connected peers")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }

    func proxySettingsSection() -> some View {
        Section {
           ProxySettingsView()
                .listRowBackground(AppDebugColors.backgroundSecondary)
                .foregroundColor(AppDebugColors.textPrimary)
        } header: {
            Text("Proxy settings")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }

}

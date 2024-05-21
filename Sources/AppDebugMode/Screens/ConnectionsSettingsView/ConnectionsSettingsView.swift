//
//  ConnectionsSettingsView.swift
//
//
//  Created by Matus Klasovity on 21/05/2024.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectionsSettingsView: View {

    @State var isBrowserPresented: Bool = false
    @EnvironmentObject var connectionsManager: ConnectionsManager

    var body: some View {
        List {
            connectedPeersSection()
            actionsSection()
        }
        .navigationTitle("Connections")
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
        .sheet(isPresented: $isBrowserPresented) {
            BrowserRepresentableViewController(
                browser: connectionsManager.browser,
                session: connectionsManager.session
            )
        }
    }

}

// MARK: - Components

private extension ConnectionsSettingsView {

    // MARK: - Sections

    func actionsSection() -> some View {
        Section {
            VStack {
                ButtonFilled(text: "Open browser") {
                    isBrowserPresented = true
                }
            }
            .listRowBackground(AppDebugColors.backgroundSecondary)
        } header: {
            Text("Actions")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }

    func connectedPeersSection() -> some View {
        Section {
            if connectionsManager.connectedPeers.isEmpty {
                Text("No connected peers")
                    .listRowBackground(AppDebugColors.backgroundSecondary)
                    .foregroundColor(AppDebugColors.textPrimary)
            }

            ForEach(connectionsManager.connectedPeers, id: \.displayName) { connectedPeer in
                Text(connectedPeer.displayName)
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
                    .foregroundColor(AppDebugColors.textPrimary)
            }
            .onDelete { offset in
                for index in offset {
                    connectionsManager.cancelConnection(to: connectionsManager.connectedPeers[index])
                }
            }
        } header: {
            Text("Connected peers")
                .foregroundColor(AppDebugColors.textSecondary)
        }
    }

}


// MARK: - BrowserRepresentableViewController

private struct BrowserRepresentableViewController: UIViewControllerRepresentable {

    let browser: MCNearbyServiceBrowser
    let session: MCSession

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = MCBrowserViewController(
            browser: browser,
            session: session
        )
        viewController.delegate = context.coordinator

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, MCBrowserViewControllerDelegate {

        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
        }

        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
        }

    }

}

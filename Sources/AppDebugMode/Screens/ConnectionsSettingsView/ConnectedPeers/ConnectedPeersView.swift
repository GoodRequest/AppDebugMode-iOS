//
//  ConnectedPeersView.swift
//  
//
//  Created by Matus Klasovity on 28/05/2024.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectedPeersView: View {

    @State var isBrowserPresented: Bool = false
    @EnvironmentObject var connectionsManager: ConnectionsManager

    var body: some View {
        Group {
            if connectionsManager.connectedPeers.isEmpty {
                Text("No connected peers")
                    .foregroundColor(AppDebugColors.textPrimary)
            }

            ForEach(connectionsManager.connectedPeers, id: \.displayName) { connectedPeer in
                Text(connectedPeer.displayName)

                    .foregroundColor(AppDebugColors.textPrimary)
            }
            .onDelete { offset in
                for index in offset {
                    connectionsManager.cancelConnection(to: connectionsManager.connectedPeers[index])
                }
            }

            ButtonFilled(text: "Open browser") {
                isBrowserPresented = true
            }
            .sheet(isPresented: $isBrowserPresented) {
                BrowserRepresentableViewController(
                    browser: connectionsManager.browser,
                    session: connectionsManager.session
                )
            }
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

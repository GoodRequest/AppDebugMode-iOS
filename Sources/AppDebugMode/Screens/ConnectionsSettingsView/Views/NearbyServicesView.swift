//
//  NearbyServicesView.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 18/06/2024.
//

import Combine
import SwiftUI
import Factory

// MARK: - Nearby services view

struct NearbyServicesView: View {

    // MARK: - Factory

    @Injected(\.sessionManager) private var sessionManager: DebugManSessionManager
    @Injected(\.nearbyServicesBrowserDelegate) private var browserDelegateWrapper: PeerBrowserDelegateWrapper

    // MARK: - State

    @State private var peers: Set<Peer> = []
    @Binding var error: (any Error)?

    // MARK: - Initialization
    
    init(error: Binding<(any Error)?>) {
        self._error = error
    }

    // MARK: - Body

    var body: some View {
        Group {
            if #available(iOS 16, *) {
                Wheel {
                    content
                }
            } else {
                VStack {
                    content
                }
            }
        }
        .task {
            Task {
                do {
                    for try await peers in browserDelegateWrapper.peerDiscoveryStream() {
                        Task { @MainActor in
                            GRHapticsManager.shared.playCustomPattern(pattern: HapticsPattern.peerDiscovery)
                        }
                        self.peers = peers
                        self.error = nil
                    }
                } catch {
                    print(error)
                    self.error = error
                }
            }
        }
    }

    @ViewBuilder private var content: some View {
        if peers.isEmpty {
            HStack {
                ProgressView()

                Text("No peers listed in browser")
                    .foregroundColor(AppDebugColors.textPrimary)
                    .font(.body)
            }
        } else {
            ForEach(peers.sorted()) { peer in
                peerView(peer)
            }
        }
    }

    @ViewBuilder private func peerView(_ peer: Peer) -> some View {
        Button {
            Task {
                try await sessionManager.invite(peer: peer, timeout: 30.0)
            }
        } label: {
            VStack {
                Image(systemName: "macbook")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .foregroundColor(AppDebugColors.primary)

                Text(peer.name)
                    .foregroundColor(AppDebugColors.textPrimary)
                    .font(.caption2)
            }
        }
        .padding()
        .background(AppDebugColors.backgroundSecondary)
        .clipShape(.capsule(style: .continuous))
        .shadow(radius: 4)
    }

}

// MARK: - Wheel layout

@available(iOS 16, *)
struct Wheel: Layout {

    var rotation: Angle = .degrees(0)

    struct Cache {
        var radius: CGFloat
    }

    func makeCache(subviews: Subviews) -> Cache {
        return Cache(radius: 0)
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        let wheelProposal = proposal.replacingUnspecifiedDimensions(by: .zero)

        let maxSubviewSize = subviews
            .map { $0.sizeThatFits(.unspecified) }
            .reduce(CGSize.zero) { CGSize(width: max($0.width, $1.width), height: max($0.height, $1.height)) }

        let largestSubviewDimension = max(maxSubviewSize.width, maxSubviewSize.height)

        #warning("TODO: fix with proper calculations based on elements' radii")
        var radius = largestSubviewDimension / 2
        for (index, subview) in subviews.dropFirst(2).enumerated() {
            let index = index + 2
            radius += largestSubviewDimension / CGFloat(index + subviews.count)
        }

        let diameter = 2 * radius
        var wheelSize = CGSize(
            width: diameter + maxSubviewSize.width,
            height: diameter + maxSubviewSize.height
        )
        wheelSize.width = max(proposal.width ?? 0, wheelSize.width)
        wheelSize.height = max(proposal.height ?? 0, wheelSize.height)

        let maxRadiusHorizontal = proposal.width ?? .infinity - maxSubviewSize.width / 2
        let maxRadiusVertical = proposal.height ?? .infinity - maxSubviewSize.height / 2
        let maxRadius = min(maxRadiusHorizontal, maxRadiusVertical)

        cache.radius = min(radius, maxRadius)

        print(wheelSize)

        return CGSize(
            width: proposal.width ?? wheelSize.width,
            height: proposal.height ?? wheelSize.height
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let angleStep = (Angle.degrees(360).radians / Double(subviews.count))

        for (index, subview) in subviews.enumerated() {
            let angle = angleStep * CGFloat(index) + rotation.radians

            var center = CGPoint(
                x: bounds.midX,
                y: bounds.midY
            )

            var point = CGPoint(x: 0, y: -cache.radius)
                .applying(CGAffineTransform(rotationAngle: angle))

            point.x += bounds.midX
            point.y += bounds.midY

            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }

}

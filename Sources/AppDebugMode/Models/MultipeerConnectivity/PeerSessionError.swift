//
//  PeerSessionError.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 27/09/2024.
//

enum PeerSessionError: Error, CustomStringConvertible {

    // Attempting to browse from a wrong state
    case browsingBlocked

    // Attempting to stop browsing from a wrong state
    case stopBrowsingBlocked

    // Attempting to invite from a wrong state
    case invitingBlocked

    // Attempting to reconnect from a wrong state
    case reconnectingBlocked

    // Attempting to reconnect from a wrong state
    case reconnectingWithoutPeer

    // Attempting to reconnect but saved peer is not available
    case reconnectingPeerNotFound

    // Attempting to send logs but connection is not available
    case sendingLogsFailed

    // Attempting to send disconnect from a wrong state
    case disconnectBlocked

    // Attempting to send unpair from a wrong state
    case unpairBlocked

    // Title for each error case, to be used in error alerts
    var title: String {
        switch self {
        case .browsingBlocked:
            return "Browsing Blocked"
        case .stopBrowsingBlocked:
            return "Stop Browsing Blocked"
        case .invitingBlocked:
            return "Inviting Blocked"
        case .reconnectingBlocked:
            return "Reconnecting Blocked"
        case .reconnectingWithoutPeer:
            return "Reconnecting Without Peer"
        case .reconnectingPeerNotFound:
            return "Reconnecting Peer Not Found"
        case .sendingLogsFailed:
            return "Sending Logs Failed"
        case .disconnectBlocked:
            return "Disconnect Blocked"
        case .unpairBlocked:
            return "Unpair Blocked"
        }
    }

    // Description for each error case
    var description: String {
        switch self {
        case .browsingBlocked:
            return "Browsing is blocked because you can only start browsing from a clean state."
        case .stopBrowsingBlocked:
            return "Stopping browsing is blocked because you can only stop browsing from a browsing state."
        case .invitingBlocked:
            return "Inviting is blocked because you can only invite from the browsing state."
        case .reconnectingBlocked:
            return "Reconnecting is blocked because you can only reconnect from the disconnected state."
        case .reconnectingWithoutPeer:
            return "Reconnecting is blocked because there is no peer to reconnect with."
        case .reconnectingPeerNotFound:
            return "Reconnecting failed because the saved peer was not found or is not available."
        case .sendingLogsFailed:
            return "Failed to send logs because the connection to another peer is not available."
        case .disconnectBlocked:
            return "Disconnecting is blocked because you can only disconnect when connected to another peer."
        case .unpairBlocked:
            return "Unpairing is blocked because you can only unpair when paired with another peer."
        }
    }
}

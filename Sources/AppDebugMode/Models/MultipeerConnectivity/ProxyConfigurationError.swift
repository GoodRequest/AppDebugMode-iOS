//
//  ProxyConfigurationError.swift
//  AppDebugMode-iOS
//
//  Created by Andrej Jasso on 01/10/2024.
//

enum ProxyConfigurationError: Error, CustomStringConvertible {

    // Attempting to request proxyConfiguration from a wrong state
    // Can only request new cetificate from a clean state and while connected
    case requestingProxyConfigurationBlocked

    // Attempting to request certificate from a wrong state
    // Can only request new cetificate from a clean state and while connected
    case requestingNewCertificateBlocked

    // Attempting to request certificate from a wrong state
    // Can only request cetificate trust while connected
    case requestingCertificateTrustBlocked

    // Attempting to send success from wrong state
    // Can only send success from testing state while connected
    case sendingSuccessBlocked

    // Attempting to request certificate from a appDebugMode
    // Can only request cetificate from a DebugMan
    case requestingCertificateFromAppDebugMode

    // Attempting to send packet but connection is not available
    // Can only send packets when connected to another peer
    case packetSendBlocked

    // Attempting to encode packet had failed
    case encodingPacketFailed

    // Testing Certificate failed. Try again when network connected is reestablished
    case testingCertificateConnectionFailed

    // Port must be a number
    case portIsNotANumber

    // Title for each error case
    var title: String {
        switch self {
        case .requestingNewCertificateBlocked:
            return "Requesting New Certificate Blocked"
        case .requestingCertificateTrustBlocked:
            return "Requesting Certificate Trust Blocked"
        case .sendingSuccessBlocked:
            return "Sending Success Blocked"
        case .requestingCertificateFromAppDebugMode:
            return "Requesting Certificate from App Debug Mode"
        case .packetSendBlocked:
            return "Packet Sending Blocked"
        case .encodingPacketFailed:
            return "Encoding Packet Failed"
        case .testingCertificateConnectionFailed:
            return "Testing Certificate Connection Failed"
        case .portIsNotANumber:
            return "Invalid Port Number"
        case .requestingProxyConfigurationBlocked:
            return "Requesting proxy configuration blocked"
        }
    }

    // Description for each error case
    var description: String {
        switch self {
        case .requestingNewCertificateBlocked:
            return "You can only request a new certificate from a clean state and while connected."
        case .requestingCertificateTrustBlocked:
            return "You can only request certificate trust while connected."
        case .sendingSuccessBlocked:
            return "You can only send success from the testing state while connected."
        case .requestingCertificateFromAppDebugMode:
            return "You can only request certificates from DebugMan, not App Debug Mode."
        case .packetSendBlocked:
            return "Packets can only be sent when connected to another peer."
        case .encodingPacketFailed:
            return "Failed to encode the packet."
        case .testingCertificateConnectionFailed:
            return "Testing certificate failed. Try again when the network connection is reestablished."
        case .portIsNotANumber:
            return "The port must be a valid number."
        case .requestingProxyConfigurationBlocked:
            return "Attempting to request proxyConfiguration from a wrong state. Can only request new cetificate from a clean state and while connected"
        }
    }
}

//
//  MemorySettingsProvider.swift
//
//
//  Created by Andrej Jasso on 09/07/2024.
//

import LifetimeTracker
import Foundation
import GoodPersistence

fileprivate enum Key {

    enum Visibility {

        static let visibleWithIssuesDetected = "visibleWithIssuesDetected"
        static let alwaysVisible = "alwaysVisible"
        static let alwaysHidden = "alwaysHidden"

    }

    enum Style {

        static let bar = "bar"
        static let circular = "circular"

    }

}

final class MemorySettingsManager: NSObject, ObservableObject {

    static let shared = MemorySettingsManager()

    private override init() {}

    @UserDefaultValue("LifetimeTrackerEnabled", defaultValue: true)
    var enabled: Bool

    @UserDefaultValue("LifetimeTrackerVisibility", defaultValue: .visibleWithIssuesDetected)
    var visibility: LifetimeTrackerDashboardIntegration.Visibility

    @UserDefaultValue("LifetimeTrackerStyle", defaultValue: .circular)
    var style: LifetimeTrackerDashboardIntegration.Style

}

extension LifetimeTrackerDashboardIntegration.Visibility: Codable, CaseIterable, Identifiable {

    public static var allCases: [LifetimeTrackerDashboardIntegration.Visibility] = [.alwaysHidden, .alwaysVisible, .visibleWithIssuesDetected]

    public var id: String { rawValue }

    var rawValue: String {
        switch self {
        case .alwaysHidden: return Key.Visibility.alwaysHidden
        case .alwaysVisible: return Key.Visibility.alwaysVisible
        case .visibleWithIssuesDetected: return Key.Visibility.visibleWithIssuesDetected
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case Key.Visibility.alwaysHidden:
            self = .alwaysHidden

        case Key.Visibility.alwaysVisible:
            self = .alwaysVisible

        case Key.Visibility.visibleWithIssuesDetected:
            self = .visibleWithIssuesDetected

        default:
            throw DecodingError.typeMismatch(
                LifetimeTrackerDashboardIntegration.Visibility.self,
                .init(codingPath: .init(), debugDescription: "Value not matching any existing cases")
            )
        }
    }

}


extension LifetimeTrackerDashboardIntegration.Style: Codable, CaseIterable, Identifiable {

    public static var allCases: [LifetimeTrackerDashboardIntegration.Style] = [.bar, .circular]

    public var id: String { rawValue }

    var rawValue: String {
        switch self {
        case .bar: return Key.Style.bar
        case .circular: return Key.Style.circular
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try? container.encode(rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case Key.Style.bar:
            self = .bar

        case Key.Style.circular:
            self = .circular

        default:
            throw DecodingError.typeMismatch(
                LifetimeTrackerDashboardIntegration.Style.self,
                    .init(codingPath: .init(), debugDescription: "Value not matching any existing cases")
            )
        }
    }

}

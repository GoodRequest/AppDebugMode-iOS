//
//  MemorySettingsView.swift
//
//
//  Created by Andrej Jasso on 09/07/2024.
//

import SwiftUI
import LifetimeTracker

struct MemorySettingsView: View {

    typealias Visibility = LifetimeTrackerDashboardIntegration.Visibility
    typealias Style = LifetimeTrackerDashboardIntegration.Style

    @StateObject var memorySettingsManager = MemorySettingsManager.shared
    @State var visibility: Visibility = MemorySettingsManager.shared.visibility
    @State var style: Style = MemorySettingsManager.shared.style
    @State var enabled: Bool = MemorySettingsManager.shared.enabled

    var body: some View {
        Group {
            if #available(iOS 15, *) {
                List {
                    visibilitySection()
                }
                .safeAreaInset(edge: .bottom) {
                    saveMemorySettingsFooter()
                }
            } else {
                ZStack(alignment: .bottom) {
                    List {
                        visibilitySection()
                    }
                    saveMemorySettingsFooter()
                }
            }
        }
        .navigationTitle("Memory Tracker")
        .listStyle(.insetGrouped)
        .listBackgroundColor(AppDebugColors.backgroundPrimary, for: .insetGrouped)
    }

}

// MARK: - Components

private extension MemorySettingsView {

    func visibilitySection() -> some View {
        Section {
            VStack {
                Group {
                    Toggle(isOn: $enabled, label: {
                        self.enabled ? Text(verbatim: "Enabled") : Text(verbatim: "Disabled")
                    })
                }
                .foregroundColor(AppDebugColors.textPrimary)

                Text("Enables tracking of hanging screens that cause memory leaks")
                    .font(.footnote)
                    .foregroundColor(AppDebugColors.textSecondary)
            }

            Picker("Visibility", selection: $visibility) {
                ForEach(Visibility.allCases, id: \.self) { visibility in
                    Text("\(visibility.rawValue)")
                        .foregroundColor(AppDebugColors.textPrimary)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(AppDebugColors.textPrimary)
            .accentColor(AppDebugColors.primary)
            .disabled(!enabled)

            Picker("Style", selection: $style) {
                ForEach(Style.allCases, id: \.self) { style in
                    Text("\(style.rawValue)")
                        .foregroundColor(AppDebugColors.textPrimary)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .foregroundColor(AppDebugColors.textPrimary)
            .accentColor(AppDebugColors.primary)
            .disabled(!enabled)

        } header: {
            Text("Life Time Tracker")
                .foregroundColor(AppDebugColors.textSecondary)
        }
        .listRowBackground(AppDebugColors.backgroundSecondary)
    }

    func saveMemorySettingsFooter() -> some View {
        VStack(spacing: 10) {
            ButtonFilled(text: "Save memory settings") {
                saveMemorySettings()
            }

            #warning("TODO: treba crashovat appku aj kvoli memory settingom?")
            Text("The app will be terminated to properly change memory sanitizer settings.")
                .multilineTextAlignment(.center)
                .foregroundColor(AppDebugColors.textSecondary)
                .font(.caption)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Glass().edgesIgnoringSafeArea(.bottom))
    }

    func saveMemorySettings() {
        memorySettingsManager.enabled = enabled
        memorySettingsManager.style = style
        memorySettingsManager.visibility = visibility

        exit(0)
    }

}

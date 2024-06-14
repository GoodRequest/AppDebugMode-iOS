//
//  ConsoleLogsSettingsView.swift.swift
//
//  Created by Andrej Jasso on 08/02/2024.
//

import SwiftUI

struct ConsoleLogsSettingsView: View {

    // MARK: - State

    @AppStorage("numberOfLinesUnwrapped", store: UserDefaults(suiteName: Constants.suiteName))
    var numberOfLinesUnwrapped = 50

    @AppStorage("shouldRedirectLogsToAppDebugMode", store: UserDefaults(suiteName: Constants.suiteName))
    var shouldRedirectLogsToAppDebugMode = !DebuggerService.debuggerConnected()

    // MARK: - Binding

    @Binding var showSettings: Bool

    // MARK: - Initializer

    init(showSettings: Binding<Bool>) {
        _showSettings = showSettings
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                List {
                    Group  {
                        Toggle(isOn: $shouldRedirectLogsToAppDebugMode, label: {
                            Text("Redirect Logs To App Debug View")
                                .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                                .listRowBackground(AppDebugColors.backgroundSecondary)
                                .foregroundColor(AppDebugColors.textPrimary)
                        })
                        .toggleStyle(SwitchToggleStyle(tint: AppDebugColors.primary))

                        Picker("Number of lines unwrapped", selection: $numberOfLinesUnwrapped) {
                            ForEach(0..<100) {
                                Text("\($0) lines")
                                    .foregroundColor(AppDebugColors.textPrimary)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(AppDebugColors.primary)
                    }
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
                    .foregroundColor(AppDebugColors.textPrimary)
                    .accentColor(AppDebugColors.primary)

                }
                .listStyle(.plain)
                .listBackgroundColor(AppDebugColors.backgroundSecondary, for: .insetGrouped)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            withAnimation {
                                shouldRedirectLogsToAppDebugMode = DebuggerService.debuggerConnected()
                            }
                        }, label: {
                            Text("Reset")
                                .foregroundColor(AppDebugColors.primary)
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            withAnimation {
                                showSettings.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(AppDebugColors.primary)
                        })
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

}

#Preview {

    ConsoleLogsSettingsView(showSettings: .constant(true))
    
}

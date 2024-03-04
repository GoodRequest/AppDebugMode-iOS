//
//  ConsoleLogsSettingsView.swift.swift
//
//
//  Created by Andrej Jasso on 08/02/2024.
//

import SwiftUI

struct ConsoleLogsSettingsView: View {

    @AppStorage("numberOfLinesUnwrapped") var numberOfLinesUnwrapped = 50
    @ObservedObject var standardOutputService: StandardOutputService
    @State private var redirectLogs = false
    @Binding var showSettings: Bool

    init(standardOutputService: StandardOutputService, showSettings: Binding<Bool>) {
        self.standardOutputService = standardOutputService
        self.redirectLogs = standardOutputService.shouldRedirectLogsToAppDebugMode
        _showSettings = showSettings
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                List {
                    Group  {
                        Toggle(isOn: $redirectLogs, label: {
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
                                self.redirectLogs = DebuggerService.debuggerConnected()
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

                ButtonFilled(text: "Save Log Settings") {
                    standardOutputService.shouldRedirectLogsToAppDebugMode = redirectLogs
                    exit(0)
                }
                .padding()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

}

struct ConsoleLogsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleLogsSettingsView(standardOutputService: .shared, showSettings: .constant(true))
    }
}

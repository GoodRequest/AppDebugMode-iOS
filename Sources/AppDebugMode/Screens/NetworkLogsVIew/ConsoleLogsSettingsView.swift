//
//  ConsoleLogsSettingsView.swift.swift
//
//
//  Created by Andrej Jasso on 08/02/2024.
//

import SwiftUI

struct ConsoleLogsSettingsView: View {

    @ObservedObject var standardOutputService: StandardOutputService
    @State private var redirectLogs = false
    @Binding var showSettings: Bool

    init(standardOutputService: StandardOutputService, showSettings: Binding<Bool>) {
        self.standardOutputService = standardOutputService
        self.redirectLogs = standardOutputService.shouldRedirectLogsToAppDebugView
        _showSettings = showSettings
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom){
                List {
                    Toggle(isOn: $redirectLogs, label: {
                        Text("Redirect Logs To App Debug View")
                            .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                            .listRowBackground(AppDebugColors.backgroundSecondary)
                            .foregroundColor(AppDebugColors.textPrimary)
                    })
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
                    .foregroundColor(AppDebugColors.textPrimary)
                }
                .listStyle(.plain)
                .listBackgroundColor(AppDebugColors.backgroundSecondary, for: .insetGrouped)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            withAnimation {
                                showSettings.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }

                ButtonFilled(text: "Save Log Settings") {
                    standardOutputService.shouldRedirectLogsToAppDebugView = redirectLogs
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

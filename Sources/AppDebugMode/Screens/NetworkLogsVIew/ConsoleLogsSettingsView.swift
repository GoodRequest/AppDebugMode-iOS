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
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $redirectLogs, label: {
                    Text("Redirect Logs To App Debug View")
                })
                .onChange(of: redirectLogs) {
                    standardOutputService.shouldRedirectLogsToAppDebugView = $0
                }
            }
            .navigationTitle("Settings")
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
        }
    }

}

struct ConsoleLogsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleLogsSettingsView(standardOutputService: .shared, showSettings: .constant(true))
    }
}

//
//  NetworkLogsView.swift
//
//
//  Created by Andrej Jasso on 25/01/2024.
//

import SwiftUI

struct ConsoleLogsView: View {

    @ObservedObject private var standardOutputService: StandardOutputService
    @State var collapsedIds: Set<UInt64> = []
    @State var showDetail = false
    @State var showSettings = false
    @State var editedString = ""

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .long
        return dateFormatter
    }

    init(standardOutputService: StandardOutputService = StandardOutputService.shared) {
        self.standardOutputService = standardOutputService
    }

    private func toggleLog(with id: UInt64) {
        if collapsedIds.contains(id) {
            collapsedIds.remove(id)
        } else {
            collapsedIds.insert(id)
        }
    }

    var body: some View {
        GeometryReader { proxy in
            if standardOutputService.shouldRedirectLogsToAppDebugMode {
                if !standardOutputService.capturedOutput.isEmpty {
                    consoleLogsList(proxy)
                } else {
                    Text("No logs captured yet")
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding()
                }
            } else {
                Text("Logs need to be redirected into app debug mode through settings")
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding()
            }
        }
        .background(AppDebugColors.backgroundSecondary.ignoresSafeArea())
        .sheet(isPresented: $showDetail, content: {
            ConsoleLogDetailView(
                editedString: $editedString,
                showDetail: $showDetail
            )
        })
        .sheet(isPresented: $showSettings, content: {
            ConsoleLogsSettingsView(
                standardOutputService: standardOutputService,
                showSettings: $showSettings
            )
        })
        .navigationTitle("Logs")
        .toolbar {
            Button(action: {
                withAnimation {
                    showSettings = true
                }
            }, label: {
                Image(systemName: "gear")
                    .foregroundColor(AppDebugColors.primary)
            })

            Button("Clear") {
                standardOutputService.clearLogs()
            }
            .foregroundColor(AppDebugColors.primary)
        }
    }

    private func consoleLogsList(_ proxy: GeometryProxy) -> some View {
        ScrollViewReader { scrollProxy in
            List(standardOutputService.capturedOutput) { log in
                let isCollapsed = collapsedIds.contains(log.id)
                VStack(spacing: 0.0) {
                    consoleLogMessage(
                        log: log,
                        proxy: proxy,
                        isCollapsed: isCollapsed
                    )

                    if !isCollapsed {
                        Text("\(dateFormatter.string(from: log.date))")
                            .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }
                .id(log.id)
                .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                .listRowBackground(AppDebugColors.backgroundSecondary)
                .foregroundColor(AppDebugColors.textPrimary)
            }
            .listStyle(.plain)
            .listBackgroundColor(AppDebugColors.backgroundSecondary, for: .insetGrouped)
            .onAppear {
                scrollProxy.scrollTo(standardOutputService.capturedOutput.last?.id, anchor: .top)
            }
        }
    }

    private func consoleLogMessage(
        log: StandardOutputService.Log,
        proxy: GeometryProxy,
        isCollapsed: Bool
    ) -> some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 0.0) {
                Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                    .foregroundColor(AppDebugColors.primary)

                Text(log.message)
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                    .lineLimit(isCollapsed ? 1 : nil)
                    .lineSpacing(4.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        toggleLog(with: log.id)
                    }
                    .onLongPressGesture(minimumDuration: 0.5) {
                        editedString = log.message
                        withAnimation {
                            showDetail = true
                        }
                    }
            }
        }
        .frame(minWidth: proxy.size.width)
    }

}

struct ConsoleLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleLogsView(standardOutputService: .shared)
    }
}

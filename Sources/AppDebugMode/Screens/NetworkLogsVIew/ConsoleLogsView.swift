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
            List(standardOutputService.capturedOutput) { log in
                let isCollapsed = collapsedIds.contains(log.id)
                VStack(spacing: 0.0) {
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 0.0) {
                            Image(systemName: collapsedIds.contains(log.id) ? "chevron.right" : "chevron.down")
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

                    if !isCollapsed {
                        Text("\(dateFormatter.string(from: log.date))")
                            .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }
                .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                .listRowBackground(AppDebugColors.backgroundSecondary)
                .foregroundColor(AppDebugColors.textPrimary)
            }
            .listStyle(.plain)
            .listBackgroundColor(AppDebugColors.backgroundSecondary, for: .insetGrouped)
        }
        .sheet(isPresented: $showDetail, content: {
            ConsoleLogDetailView(
                editedString: $editedString,
                showDetail: $showDetail
            )
        })
        .navigationTitle("Logs")
        .toolbar {
            Button("Clear") {
                standardOutputService.clearLogs()
            }
        }
    }


}

struct ConsoleLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleLogsView(standardOutputService: .shared)
    }
}

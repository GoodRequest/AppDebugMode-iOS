//
//  NetworkLogsView.swift
//
//
//  Created by Andrej Jasso on 25/01/2024.
//

import SwiftUI

struct ConsoleLogsView: View {

    @ObservedObject private var standardOutputService: StandardOutputService
    @State var unwrappedIds: Set<UInt64> = []
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
        if unwrappedIds.contains(id) {
            unwrappedIds.remove(id)
        } else {
            unwrappedIds.insert(id)
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
        .background(AppDebugColors.backgroundPrimary.ignoresSafeArea())
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
                showSettings = true
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
                let isUnwrapped = unwrappedIds.contains(log.id)
                ZStack(alignment: .topTrailing){
                    VStack(spacing: 0.0) {
                        consoleLogMessage(
                            log: log,
                            proxy: proxy,
                            isUnwrapped: isUnwrapped
                        )

                        if isUnwrapped {
                            Text("\(dateFormatter.string(from: log.date))")
                                .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                        }
                    }
                    .id(log.id)
                    .padding([.top], 2.0)

                    Image(systemName: isUnwrapped ? "chevron.down" : "chevron.right")
                        .imageScale(.small)
                        .foregroundColor(AppDebugColors.primary)
                        .padding(2.0)
                        .background(AppDebugColors.backgroundSecondary.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    Image(systemName: "ellipsis.circle")
                        .imageScale(.small)
                        .padding(2.0)
                        .background(AppDebugColors.backgroundSecondary.opacity(0.8))
                        .clipShape(Circle())
                        .onTapGesture {
                            editedString = log.message
                            showDetail = true
                        }
                }
                .frame(minWidth: proxy.size.width)
                .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                .listRowBackground(AppDebugColors.backgroundSecondary)
                .foregroundColor(AppDebugColors.textPrimary)
                .onTapGesture {
                    toggleLog(with: log.id)
                }
                .onLongPressGesture(minimumDuration: 0.5) {
                    editedString = log.message
                    showDetail = true
                }
            }
            
            .listStyle(.plain)
            .onAppear {
                scrollProxy.scrollTo(standardOutputService.capturedOutput.last?.id, anchor: .top)
            }
        }
    }

    private func consoleLogMessage(
        log: StandardOutputService.Log,
        proxy: GeometryProxy,
        isUnwrapped: Bool
    ) -> some View {
        ScrollView(.horizontal) {
            Text(log.message)
                .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                .lineLimit(isUnwrapped ? nil : 1)
                .lineSpacing(4.0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
        }
        .scrollIndicatorsIf16Plus(hidden: true)
    }

}

struct ConsoleLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleLogsView(standardOutputService: .testService)
    }
}

fileprivate extension View {

    func scrollIndicatorsIf16Plus(hidden: Bool) -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(hidden ? .hidden : .visible)
        } else {
            return self
        }
    }

}

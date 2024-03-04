//
//  NetworkLogsView.swift
//
//
//  Created by Andrej Jasso on 25/01/2024.
//

import SwiftUI

struct ConsoleLogsView: View {

    @Environment(\.hostingControllerHolder) var viewControllerHolder
    @AppStorage("numberOfLinesUnwrapped") var numberOfLinesUnwrapped = 50

    @ObservedObject private var standardOutputService: StandardOutputService
    @State var unwrappedIds: Set<UInt64> = []
    @State var isLoading = false
    @State var showSettings = false
    @State var didScroll = false


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
            ZStack {
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

                if isLoading {
                    Color.black.opacity(0.6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppDebugColors.primary))
                        .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
                }
            }
        }
        .background(AppDebugColors.backgroundPrimary.ignoresSafeArea())
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
            .disabled(isLoading)

            Button("Clear") {
                standardOutputService.clearLogs()
            }
            .foregroundColor(AppDebugColors.primary)
            .disabled(isLoading)
        }
    }

    private func consoleLogsList(_ proxy: GeometryProxy) -> some View {
        ScrollViewReader { scrollProxy in
            ZStack {
                List(standardOutputService.capturedOutput) { log in
                    let isUnwrapped = unwrappedIds.contains(log.id)
                    ZStack(alignment: .topTrailing) {
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
                        .padding([.top], 2.0)

                        Image(systemName: "ellipsis.circle")
                            .imageScale(.small)
                            .padding(2.0)
                            .background(AppDebugColors.backgroundSecondary.opacity(0.8))
                            .clipShape(Circle())
                            .onTapGesture { pushDetail(logMessage: log.message) }

                        Image(systemName: isUnwrapped ? "chevron.down" : "chevron.right")
                            .imageScale(.small)
                            .foregroundColor(AppDebugColors.primary)
                            .padding(2.0)
                            .background(AppDebugColors.backgroundSecondary.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(.horizontal, 8)
                    .frame(minWidth: proxy.size.width)
                    .id(log.id)
                    .listRowSeparatorColor(AppDebugColors.primary, for: .insetGrouped)
                    .listRowBackground(AppDebugColors.backgroundSecondary)
                    .foregroundColor(AppDebugColors.textPrimary)
                    .onTapGesture {
                        toggleLog(with: log.id)
                    }
                    .onLongPressGesture(minimumDuration: 0.5) { pushDetail(logMessage: log.message)}
                }
                .listStyle(.plain)
                .onAppear {
                    if !didScroll {
                        scrollProxy.scrollTo(standardOutputService.capturedOutput.last?.id, anchor: .top)
                        didScroll = true
                    }
                    isLoading = false
                }

                Image(systemName: "arrow.down.circle")
                    .imageScale(.large)
                    .foregroundColor(AppDebugColors.primary)
                    .padding(4.0)
                    .background(Color.gray.opacity(0.8))
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .onTapGesture {
                        withAnimation {scrollProxy.scrollTo(standardOutputService.capturedOutput.last?.id, anchor: .top)
                        }
                    }
            }
        }
    }

    private func pushDetail(logMessage: String) {
        withAnimation {
            isLoading = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewControllerHolder?.controller?.navigationController?.pushViewController(
                ConsoleLogDetailViewController(text: logMessage),
                animated: false
            )
        }
    }

    private func consoleLogMessage(
        log: StandardOutputService.Log,
        proxy: GeometryProxy,
        isUnwrapped: Bool
    ) -> some View {
        Text(log.message)
            .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
            .truncationMode(.middle)
            .allowsTightening(true)
            .lineLimit(isUnwrapped ? numberOfLinesUnwrapped : 1)
            .lineSpacing(4.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.trailing, 32)
    }

}

struct ConsoleLogsView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleLogsView(standardOutputService: .testService)
    }
}

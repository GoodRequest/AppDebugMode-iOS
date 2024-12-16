//
//  StandardOutputService.swift
//
//  Created by Andrej Jasso on 29/01/2024.
//

import SwiftUI

public actor StandardOutputProcessor: ObservableObject {

    public static let shared = StandardOutputProcessor()

    // MARK: - Properties

    private var didRedirectLogs = false
    private let stdOutPipe = Pipe()
    private let stdErrPipe = Pipe()
    private let count = 0

    @AppStorage("shouldRedirectLogsToAppDebugMode", store: UserDefaults(suiteName: Constants.suiteName))
    var shouldRedirectLogsToAppDebugMode = !DebuggerService.debuggerConnected() {
        didSet {
            if shouldRedirectLogsToAppDebugMode {
                redirectLogsToAppDebugMode()
            }
        }
    }

    @AppStorage("capturedOutput", store: UserDefaults(suiteName: Constants.suiteName))
    var capturedOutput: [Log] = []

    @AppStorage("numberOfStoredLogs") var numberOfStoredLogs = 30

    // MARK: - Helper functions

    func redirectLogsToAppDebugMode() {
        if capturedOutput.count > numberOfStoredLogs {
            capturedOutput = Array(capturedOutput.prefix(upTo: numberOfStoredLogs))
        }

        guard !didRedirectLogs else { return } // redirect only once
        didRedirectLogs = true

        setvbuf(stdout, nil, _IONBF, 0) // set output as unbuffered
        dup2(stdOutPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        stdOutPipe.fileHandleForReading.readabilityHandler = { [weak self] handler in
            let readString = String(data: handler.availableData, encoding: .utf8) ?? "<\(handler.availableData.count) bytes of non-UTF-8 data>\n"
            Task {
                await self?.redirectLog(readString)
            }
        }

        setvbuf(stderr, nil, _IONBF, 0) // set output as unbuffered
        dup2(stdErrPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        stdErrPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            var readString = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes of non-UTF-8 data>\n"

            // Trim OSLog metadata prefix
            if let regex = try? NSRegularExpression(pattern: #"^(\nOSLOG-.*?\t)"#, options: [.anchorsMatchLines]),
               let match = regex.firstMatch(in: readString, options: [], range: NSRange(location: 0, length: readString.utf16.count)),
               let range = Range(match.range, in: readString) {
                readString = readString.replacingCharacters(in: range, with: "")

            }
            Task {
                await self?.redirectLog(readString)
            }
        }
    }

    func redirectLog(_ string: String) async {
        if shouldRedirectLogsToAppDebugMode {
            let log = Log(message: string)
            guard !log.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            self.capturedOutput.append(log)
        }
    }

}

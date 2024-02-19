//
//  StandardOutputService.swift
//
//
//  Created by Andrej Jasso on 29/01/2024.
//

import SwiftUI
import GoodPersistence

final class StandardOutputService: ObservableObject {

    // MARK: - Singleton

    static var shared = StandardOutputService()

    // MARK: - Log

    struct Log: Identifiable {

        var id: UInt64 {
            absoluteSystemTime
        }

        let message: String
        let date = Date()

        private let absoluteSystemTime: UInt64 = mach_absolute_time()

    }

    // MARK: - Variables

    @Published var capturedOutput: [Log] = []

    private var didRedirectLogs: Bool = false
    private var pipe = Pipe()
    private var count = 0

    @UserDefaultValue("shouldRedirectLogsToAppDebugMode", defaultValue: !DebuggerService.debuggerConnected())
    var shouldRedirectLogsToAppDebugMode: Bool

    // MARK: - Helper functions

    func redirectLogsToAppDebugMode () {
        guard !didRedirectLogs else { return } // redirect only once
        didRedirectLogs = true

        setvbuf(stdout, nil, _IONBF, 0) // set output as unbuffered
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            let str = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes of non-UTF-8 data>\n"

            self?.redirectLog(str)
        }

        dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            var str = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes of non-UTF-8 data>\n"

            let regex = try! NSRegularExpression(pattern: #"^(OSLOG-.*?$)"#, options: [.anchorsMatchLines])
            if let match = regex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count)) {

                let range = Range(match.range, in: str)!
                str = str.replacingCharacters(in: range, with: "")
            }

            self?.redirectLog(str)
        }
    }

    func redirectLog(_ string: String) {
        DispatchQueue.main.async { [weak self] in
            let log = Log(message: string)
            guard !log.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            self?.capturedOutput.append(log)
        }
    }

    func clearLogs() {
        capturedOutput.removeAll()
    }

}

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

    static let testService: StandardOutputService = {
        let service = StandardOutputService()
        let sampleValues = [
        """
        🚀 GET https://myfakeapi.com/api/cars/4
        🏷 Headers: empty headers
        ↗️ Start: 2024-02-26 16:41:53 +0000
        ⌛️ Duration: 0.3984450101852417s
        ✅ 200
        ⬇️ Response body:
        {
          "Car" : {
            "availability" : false,
            "id" : 4,
            "car" : "Jeep",
            "car_model" : "Compass",
            "car_vin" : "4USBT33454L511606",
            "price" : "$2732.99",
            "car_color" : "Violet",
            "car_model_year" : 2012
          }
        }
        """,
        """
        🚀 GET https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft
        🏷 Headers: empty headers
        ↗️ Start: 2024-02-26 16:41:53 +0000
        ⌛️ Duration: 0.3984450101852417s
        ✅ 200
        ⬇️ Response body:
        {
          "Car" : {
            "availability" : false,
            "id" : 4,
            "car" : "Jeep",
            "car_model" : "Compass",
            "car_vin" : "4USBT33454L511606",
            "price" : "$2732.99",
            "car_color" : "Violet",
            "car_model_year" : 2012
          }
        }

        """
        ].map {
            Log(message: $0)
        }
        service.capturedOutput = sampleValues
        return service
    }()

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
            let readString = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes of non-UTF-8 data>\n"

            self?.redirectLog(readString)
        }

        //OSLog/Console logs are written to stderr
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            var readString = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes of non-UTF-8 data>\n"

            // Trim OSLog metadata prefix
            if let regex = try? NSRegularExpression(pattern: #"^(\nOSLOG-.*?\t)"#, options: [.anchorsMatchLines]),
               let match = regex.firstMatch(in: readString, options: [], range: NSRange(location: 0, length: readString.utf16.count)),
               let range = Range(match.range, in: readString) {
                readString = readString.replacingCharacters(in: range, with: "")

            }

            self?.redirectLog(readString)
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

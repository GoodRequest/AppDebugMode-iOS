//
//  StandardOutputService.swift
//
//
//  Created by Andrej Jasso on 29/01/2024.
//

import SwiftUI

public class StandardOutputService: ObservableObject {

    public static var shared = StandardOutputService()

    struct Log: Identifiable {

        var id: UInt64 {
            uptime
        }

        let message: String
        let date = Date()

        private let uptime: UInt64 = mach_absolute_time()

    }

    @Published var capturedOutput: [Log] = []

    private var pipe = Pipe()
    private var count = 0

    public func openConsolePipe () {
        setvbuf(stdout, nil, _IONBF, 0)
        dup2(pipe.fileHandleForWriting.fileDescriptor,
            STDOUT_FILENO)
        pipe.fileHandleForReading.readabilityHandler = {
         [weak self] handle in
        let data = handle.availableData
        let str = String(data: data, encoding: .utf8) ?? "<Non-utf8 data of size\(data.count)>\n"
        DispatchQueue.main.async {
            let log = Log(message: str)
            guard !log.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            self?.capturedOutput.append(log)
        }
      }
    }

    public func clearLogs() {
        capturedOutput.removeAll()
    }

}

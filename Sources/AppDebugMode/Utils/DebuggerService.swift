//
//  DebuggerService.swift
//  AppDebugMode-iOS
//
//  Created by Filip Šašala on 15/02/2024.
//

import Foundation

public final class DebuggerService {

    public static func debuggerConnected() -> Bool {
        var processInfo = kinfo_proc()
        var processInfoSize = MemoryLayout.stride(ofValue: processInfo)

        var processIdentifiers: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]

        let error = sysctl(&processIdentifiers, UInt32(processIdentifiers.count), &processInfo, &processInfoSize, nil, 0)
        guard error == 0 else {
            assertionFailure("sysctl failed")
            return false
        }

        return (processInfo.kp_proc.p_flag & P_TRACED) != 0
    }

}

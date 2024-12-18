//
//  FirebaseMessaging.swift
//  
//
//  Created by Matus Klasovity on 17/08/2023.
//

import Foundation

@objc protocol AppDebugFirebaseMessaging: Sendable {

    func deleteTokenWith(completion: @escaping ((Error?) -> Void))
    var FCMToken: String? { get }
    func tokenWith(completion: @escaping ((String?, Error?) -> Void))
    
}


extension AppDebugFirebaseMessaging {
    
    func deleteToken() async throws {
        try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
            deleteTokenWith { error in
                if let error {
                    continuation.resume(with: .failure(error))
                } else {
                    continuation.resume(with: .success(()))
                }
            }
        }
    }
    
    func token() async throws -> String {
        try await withUnsafeThrowingContinuation { continuation in
            tokenWith { token, error in
                if let error {
                    continuation.resume(with: .failure(error))
                } else {
                    continuation.resume(with: .success(token ?? ""))
                }
            }
        }
    }
    
    var fmcToken: String? {
        FCMToken
    }
    
}

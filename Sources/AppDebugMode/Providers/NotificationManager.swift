//
//  NotificationManager.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Sebastian Mraz on 16/07/2024.
//

import Foundation

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    func send() {
        let topic = "sk.azet.Bistro-sk"
        let pushType = "alert"
        let deviceToken = "8019B785ED25A275FEE6382092F5414450325700B9D8334753F7F5074913F9BECCEB937352058C5A6D8D29FCB0C3DB1139BA6B9B8F63FC095E53CC060868771616447B2AA1B12E681AD6CE9244EE6DBF"
        let payload = [
            "aps": [
                "alert": [
                    "title": "Title",
                    "body": "Body"
                ]
            ]
        ]
        
        if let url = URL(string: "https://api.sandbox.push.apple.com/3/device/\(deviceToken)"),
           let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(topic, forHTTPHeaderField: "apns-topic")
            request.setValue(pushType, forHTTPHeaderField: "apns-push-type")
            request.httpBody = jsonData
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error {
                    print("error: \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("invalid response")
                    return
                }
                
                print("Response: \(httpResponse.statusCode)")
            }
            task.resume()
        }
        
    }
    
//    func send(notification: NotificationModel) {
//        // 
//    }
    
}

// MARK: - URLSessionDelegate

extension NotificationManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let p12URL = documentsURL.appendingPathComponent("bisAPNS.p12")
        
        guard fileManager.fileExists(atPath: p12URL.path) else {
            print("Error: .p12 file not found in Documents directory.")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        do {
            let p12Data = try Data(contentsOf: p12URL)
            
            let importPasswordOption: NSDictionary = [kSecImportExportPassphrase as NSString: "123456789"]
            var items: CFArray?
            let securityError = SecPKCS12Import(p12Data as NSData, importPasswordOption, &items)
            
            guard securityError == errSecSuccess else {
                print("Error importing .p12 file: \(securityError)")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            guard let array = items as? [[String: Any]],
                  let identity = array.first?[kSecImportItemIdentity as String] else {
                print("Error extracting identity from .p12 file")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            let credential = URLCredential(identity: identity as! SecIdentity, certificates: nil, persistence: .forSession)
            completionHandler(.useCredential, credential)
            
        } catch {
            print("Error loading .p12 file data: \(error.localizedDescription)")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
}

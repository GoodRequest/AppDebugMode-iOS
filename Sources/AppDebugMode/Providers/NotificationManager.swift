//
//  NotificationManager.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Sebastian Mraz on 16/07/2024.
//

import Foundation
import GoodPersistence

public final class AppDebugModeNotificationManager: NSObject {
    
    public static let shared = AppDebugModeNotificationManager()
    
    public var deviceToken: String?
    
    func send(notification: NotificationModel, with urlSessionDelegate: URLSessionDelegate) {
        guard let deviceToken = notification.deviceToken.isEmpty ? deviceToken : notification.deviceToken,
              let topic = notification.topic.isEmpty ? Bundle.main.bundleIdentifier : notification.topic else {
            return
        }
        
        if let url = URL(string: "https://api.sandbox.push.apple.com/3/device/\(deviceToken)") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(topic, forHTTPHeaderField: "apns-topic")
            request.setValue(notification.notificationType.rawValue, forHTTPHeaderField: "apns-push-type")
            guard let payloadData = notification.payload.data(using: .utf8) else {
                print("Error: Unable to convert payload string to data")
                return
            }
            
            request.httpBody = payloadData
            
            let session = URLSession(configuration: .default, delegate: urlSessionDelegate, delegateQueue: nil)
            
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
    
}



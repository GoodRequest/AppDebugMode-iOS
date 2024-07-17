//
//  HomeViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import Foundation
import UIKit

final class HomeViewModel {

    // MARK: - Constants
    
    private let coordinator: Coordinator<AppStep>
    
    // MARK: - Initializer
    
    init(coordinator: Coordinator<AppStep>) {
        self.coordinator = coordinator
    }
    
}

// MARK: - Public

extension HomeViewModel {
    
    func goToFetch() {
        coordinator.navigate(to: .home(.goToFetch))
    }
    
    func goToLogin() {
        coordinator.navigate(to: .home(.goToLogin))
    }
    
    func goToSettings() {
        coordinator.navigate(to: .home(.goToSettings))
    }
    
    func send(from controller: UIViewController) {
        let topic = "sk.azet.Bistro-sk"
        let pushType = "alert"
        let deviceToken = "80b03e35c3f192f423bd0686f0aa7bde37868b314ae09c2a553cd8c9c96f78898b703bcaa01e28e237bf68dc89d978e15afd7fd876668cdfe0d1409066bc69d5d27708dcf8f5efa499180643b75ce45f"
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
            
            let session = URLSession(configuration: .default, delegate: controller as? URLSessionDelegate, delegateQueue: nil)
            
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

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

//
//  NotificationModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Sebastian Mraz on 16/07/2024.
//

import Foundation
 
struct NotificationModel {
    
    // lets

    let title: String
    let body: String
    
    // asJson -> Sting
    
    var asJson: String {
        """
        {
            "aps":{"alert":{
                "title": \(title),
                "body": \(body)
            }}
        }
        """
    }
    
}

//
//  NotificationModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Sebastian Mraz on 16/07/2024.
//

import Foundation

struct NotificationModel {
    
    /// Example
    /// ```
    /// let topic = "sk.azet.Bistro-sk"
    /// let deviceToken = "8019B785ED25A275FEE6382092F5414450325700B9D8334753F7F5074913F9BECCEB937352058C5A6D8D29FCB0C3DB1139BA6B9B8F63FC095E53CC060868771616447B2AA1B12E681AD6CE9244EE6DBF"
    /// let payload = [
    ///     "aps": [
    ///         "alert": [
    ///             "title": "Title",
    ///             "body": "Body"
    ///         ]
    ///     ]
    /// ]
    /// ```
    
    // MARK: - Property
    
    let topic: String
    let deviceToken: String
    let notificationType: NotificationType
    
    let payload: String
    
}

enum NotificationType: String {
    
    case alert
    case background
    
    var title: String {
        switch self {
        case .alert:
            return "Alert"
        case .background:
            return "Background"
        }
    }
    
    var payload: String {
        switch self {
        case .alert:
            return """
             {
                 "aps": {
                     "alert": {
                         "title": "\(self.title)",
                         "body": "This is an alert notification"
                     }
                 }
             }
             """
        case .background:
            return """
             {
                 "aps": {
                     "content-available": 1
                 },
                 "data": {
                     "customKey": "customValue"
                 }
             }
             """
        }
    }
    
}

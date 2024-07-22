//
//  CloudPushNotificationsViewModel.swift
//
//
//  Created by Sebastian Mraz on 19/07/2024.
//

import Foundation

enum CloudPushNotificationsValidationError: Error, Identifiable {

    case fieldsEmpty

    var id: String {
        self.localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .fieldsEmpty:
            return "Required fields are empty or Certificate is missing"
        }
    }

}

final class CloudPushNotificationsViewModel: NSObject, ObservableObject {

    @Published var notificationType: NotificationType = .alert
    
    @Published var certificate: Data?
    @Published var certificateName: String?
    @Published var certificatePassword: String = ""
    
    @Published var customPayload: String = NotificationType.alert.payload

    @Published var deviceToken: String = AppDebugModeNotificationManager.shared.deviceToken ?? ""
    @Published var appId: String =  Bundle.main.bundleIdentifier ?? ""

    @Published var validationError: CloudPushNotificationsValidationError?

}

extension CloudPushNotificationsViewModel {
    
    func send() {
        guard let _ = certificate, !certificatePassword.isEmpty, notificationType != nil, !customPayload.isEmpty else {
            validationError = .fieldsEmpty

            return
        }
        
        AppDebugModeNotificationManager.shared.send(
            notification: .init(
                topic: appId,
                deviceToken: deviceToken,
                notificationType: notificationType, 
                payload: customPayload
            ),
            with: self
        )
    }
    
    func read(from url: URL) -> Result<Data, Error> {
        do {
            let data = try Data(contentsOf: url)
            certificateName = url.lastPathComponent
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
}

// MARK: - URLSessionDelegate

extension CloudPushNotificationsViewModel: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
          guard let p12Data = certificate else {
              print("No .p12 data available")
              completionHandler(.cancelAuthenticationChallenge, nil)
              return
          }
          
          let importPasswordOption: NSDictionary = [kSecImportExportPassphrase as NSString: certificatePassword]
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
      }
    
}


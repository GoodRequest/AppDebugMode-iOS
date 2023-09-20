//
//  File.swift
//  
//
//  Created by Matus Klasovity on 30/07/2023.
//

import UIKit

final class AppDirectorySettingsViewModel: ObservableObject {
    
    // MARK: - State
    
    @Published var alert: Alert?
    
    // MARK: - Enums
    
    enum Alert: Identifiable {
        
        case clearDirectoryError(Error)
        case clearDirectoryConfrimation
        
        var id: String {
            UUID().uuidString
        }
        
    }
    
    // MARK: - Public

    func openAppFilesDirectory() {
        let documentsUrl = getDocumentsDirectory()

        if let sharedUrl = URL(string: "shareddocuments://\(documentsUrl.path)") {
            if UIApplication.shared.canOpenURL(sharedUrl) {
                UIApplication.shared.open(sharedUrl, options: [:])
            }
        }
    }
    
    func clearAppFilesDirectory() {
        do {
            let documentsUrl = getDocumentsDirectory()
            let contents = try FileManager.default.contentsOfDirectory(atPath: documentsUrl.path)
            let urls = contents.map { URL(string:"\(documentsUrl.appendingPathComponent("\($0)"))")! }

            urls.forEach {  try? FileManager.default.removeItem(at: $0) }
        } catch {
            alert = .clearDirectoryError(error)
        }
     }
    
}

// MARK: - Private

private extension AppDirectorySettingsViewModel {

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}

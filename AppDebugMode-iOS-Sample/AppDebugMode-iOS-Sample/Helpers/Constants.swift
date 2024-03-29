//
//  Constants.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 19/09/2023.
//

import Foundation
#if DEBUG
import AppDebugMode
#endif

struct Constants {
    
    // MARK: Insets
    
    struct Insets {
        
        static let edgeInset = 16.0
        
    }
    
    // MARK: - Texts
    
    struct Texts {
        
        struct Home {
            
            static let title = "App Debug Mode"
            static let description = "...allows an iOS application to select an API Server and User for the app during runtime"
            static let login = "User Login Mode"
            static let fetch = "API Server Mode"
            static let userDefaults = "User Profile Mode"
            
        }
        
        struct Fetch {
            
            static let fetchLarge = "Fetch Large"
            static let fetch = "Tap to fetch"
            static let placeHolder = "Empty"
            
        }
        
        struct Login {
            
            static let loginTitle = "Name"
            static let loginPlaceholder = "Enter your login name"
            static let passwordTitle = "Password"
            static let passwordPlaceholder = "Enter your login password"
            
        }
        
        struct Profile {
            
            static let nameTitle = "Full name"
            static let namePlaceholder = "Enter your full name"
            static let genderOptions = ["Male", "Female"]
            
        }
        
    }
    
    // MARK: - Servers
    
    enum ProdServer {
        
        static let name = "CARS"
        static let url  = "https://myfakeapi.com/api/"
        
    }
    
    enum DevServer {
        
        static let name = "PRODUCTS"
        static let url = "https://fakestoreapi.com/"
        
    }
    
    #if DEBUG
    enum ServersCollections {
        
        static let sampleBackend = ApiServerCollection(
            name: "SAMPLE backend",
            servers: [
                Constants.Servers.prod,
                Constants.Servers.dev
            ],
            defaultSelectedServer: Constants.Servers.dev
        )
        
        static var allClases: [ApiServerCollection] = [
            Self.sampleBackend
        ]
        
    }
    
    enum Servers {

        static let prod = ApiServer(name: ProdServer.name, url: ProdServer.url)
        static let dev = ApiServer(name: DevServer.name, url: DevServer.url)
        
    }
    #endif
    
}

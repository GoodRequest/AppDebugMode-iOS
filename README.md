# AppDebugMode

Swift Package ***AppDebugMode*** is a library that allows an iOS application to select an API Server and User for the app during runtime. This can be helpful during development and testing phases of the application. With ***AppDebugMode***, developers and testers can easily switch between development, staging, and production environments without recompiling the application. Additionally, it allows developers and testers to select different users test different scenarios in the app.

## Instalation

### 1. Add Swift Package
```swift
/// Package.swift
dependencies: [
    .package(url: "git@github.com:GoodRequest/AppDebugMode-iOS.git", .upToNextMajor(from: "1.0.0"))
]
```

### 2. Exclude AppDebugMode package from Release sceheme
![Exclude AppDubugMode Example](screenshot.png)


## Setup 
```swift
/// AppDelegate.swift
#if DEBUG
import AppDebugModel
#endif

#if DEBUG
    enum ServersCollections {

        static let myAppBackend = ApiServerCollection(
            name: "My App backend",
            servers: [
                Servers.prod,
                Servers.dev
            ],
            defaultSelectedServer: Servers.dev
        )

        static var allCases: [ApiServerCollection] = [
            Self.myAppBackend
        ]

    }

    enum Servers {
        
        static let prod = ApiServer(name: "PROD", url: "https://api.production.example")
        static let dev = ApiServer(name: "DEV", url: "https://test.api")
        
    }
#endif

// didFinishLaunchingWithOptions:
#if DEBUG
    AppDebugModeProvider.shared.setup(
        serversCollections: ServersCollections.allCases,
        onServerChange: { 
            // logout user
        }
    )
#endif
```

## Get selected server

```swift
#if DEBUG
import AppDebugModel
#endif

var baseURL: String {
    #if DEBUG
    return AppDebugModeProvider.shared.getSelectedServer(for: ServersCollections.myAppBackend).url
    #else
    return "https://api.production.example"
    #endif
}
```

## Get selected user

```swift
#if DEBUG
import AppDebugModel
#endif

#if DEBUG
    AppDebugModeProvider.shared.selectedTestingUserPublisher
        .sink { [weak self] in
            self?.emailTextField.text = $0?.name
            self?.passwordTextField.text = $0?.password
        }
        .store(in: &cancellables)
#endif
```

## Activation in App
In app you can activate debug mode by shaking device or in simulator by `CMD + CTRL + Z`

<img src="simulator-screenshot-1.png" alt="App Activation Example" height="600">

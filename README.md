# AppDebugMode

Swift Package ***AppDebugMode*** is a library that allows an iOS application to select an API Server and User for the app during runtime. This can be helpful during development and testing phases of the application. With ***AppDebugMode***, developers and testers can easily switch between development, staging, and production environments without recompiling the application. Additionally, it allows developers and testers to select different users test different scenarios in the app.

![App Debug Mode](https://github.com/GoodRequest/AppDebugMode-iOS/assets/78155066/3ea95aa3-87d3-4d81-ad9a-5bdf1981789f)


## Instalation

### 1. Add Swift Package
```swift
/// Package.swift
dependencies: [
    .package(url: "git@github.com:GoodRequest/AppDebugMode-iOS.git", .upToNextMajor(from: "1.2.0"))
]
```

### 2. Exclude AppDebugMode package from Release scheme
<img src="Screenshots/package-exclude.png" alt="Exclude AppDebugMode package example" height="200" />


## Setup 
```swift
/// AppDelegate.swift
#if DEBUG
import AppDebugMode
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

// `didFinishLaunchingWithOptions` (before starting coordinator):
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
import AppDebugMode
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
import AppDebugMode
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

## Cache setup
> **Warning:** To ensure the proper functioning of the cache manager, you need to utilize the [GoodPersistence](https://github.com/GoodRequest/GoodPersistence) properties in your cache manager.

```swift
/// AppDelegate.swift
#if DEBUG
    AppDebugModeProvider.shared.setup(
        serversCollections: ServersCollections.allCases,
        onServerChange: { 
            // logout user
        },
        cacheManager: // optional - provide your own cache manager
    )
#endif
```

<img src="Screenshots/cache-manager.png" alt="Cache manager example" height="600" />

## Push notifications
If you want to use push notifications in debug mode, you need to pass `Messaging.Messaging()` object into `AppDebugModeProvider.shared.setup()` method.

```swift
// didFinishLaunchingWithOptions

// essential configuration
FirebaseConfiguration.shared.setLoggerLevel(.min)
FirebaseApp.configure()

#if DEBUG
AppDebugModeProvider.shared.setup(
    serversCollections: C.ServersCollections.allCases,
    onServerChange: { },
    cacheManager: dependencyContainer.cacheManager,
    firebaseMessaging: Messaging.messaging() // Firebase messaging object
)
#endif
```

## Console logs redirection
If you want to redirect logs call this snippet of code in AppDelegate or a different preferred spot. Keep in mind this must be turned on in the AppDebugMode settings and the app must be running in a DEBUG configuration
```swift
// didFinishLaunchingWithOptions

#if DEBUG

if StandardOutputService.shared.shouldRedirectLogsToAppDebugView {
    StandardOutputService.shared.redirectLogsToAppDebugView()
}

#endif
```

## Debugman connection
If you want to enable app to send logs to Debugman you need to add following to your Info.plist file.
```xml
<key>NSBonjourServices</key>
<array>
    <string>_Debugman._tcp</string>
</array>
<key>NSLocalNetworkUsageDescription</key>
<string>Proxy and debugger connection when running in DEBUG mode</string>
```

To enable proxy for Debugman you need to add AppDebugMode Proxy URL Sessiion Config to your Network session.
```swift
#if DEBUG
let urlSessionConfig = AppDebugModeProvider.shared.proxySettingsProvider.urlSessionConfiguration
#else
let urlSessionConfig = URLSessionConfiguration.default
#endif

session = NetworkSession(
    baseUrl: baseServer.rawValue,
    configuration: NetworkSessionConfiguration(
        urlSessionConfiguration: urlSessionConfig,
        interceptor: nil,
        eventMonitors: [monitor]
    )
)
```
   
## Activation in App
- In app you can activate debug mode by shaking device or in simulator by `CMD + CTRL + Z`
- To open debug mode with other actions in the app initialize ViewController with `let debugViewController = AppDebugModeProvider.shared.start()`

<img src="Screenshots/app-showcase.gif" alt="App activation showcase" height="30%" width="30%"/>

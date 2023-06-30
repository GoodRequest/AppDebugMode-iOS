# AppDebugMode

Swift Package ***AppDebugMode*** is a library that allows an iOS application to select an API Server and User for the app during runtime. This can be helpful during development and testing phases of the application. With ***AppDebugMode***, developers and testers can easily switch between development, staging, and production environments without recompiling the application. Additionally, it allows developers and testers to select different users test different scenarios in the app.

## Setup 
```swift
/// AppDelegate.swift
import AppDebugModel

// didFinishLaunchingWithOptions:
#if DEBUG
    AppDebugModeProvider.shared.setup(
        defaultServer: yourServer,
        availableServers: [],
        onServerChange: { _ in  } // Log out user 
    )
#endif
```

## Get selected user

```swift
#if DEBUG
    AppDebugModeProvider.shared.selectedTestingUserPublisher
        .sink { [weak self] in
            self?.emailTextField.text = $0?.name
            self?.passwordTextField.text = $0?.password
        }
        .store(in: &cancellables)
#endif
```

## Get selected server

```swift
var baseURL: String {
    #if DEBUG
    return AppDebugModeProvider.shared.selectedServer.url
    #else
    return "https://api.production.example"
}
```
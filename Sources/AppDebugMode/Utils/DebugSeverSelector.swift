//
//  BaseUrlProvider.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 24/09/2024.
//

import Foundation
import GoodNetworking

enum CustomServerError: Error {

    case invalidUrl
    case repeatedName

}

public actor DebugSelectableServerProvider: ObservableObject, Identifiable, Hashable {

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: DebugSelectableServerProvider, rhs: DebugSelectableServerProvider) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Properties

    public let id: String = UUID().uuidString

    // MARK: - State
    
    private let userDefaults = UserDefaults(suiteName: "CustomBaseUrlProvider")
    public var serverCollection: ApiServerCollection
    public var onServerChange: CheckedContinuation<ApiServer, Never>?
    public var customServers: [ApiServer] = []
    public var selectedServerName: String = ""

    // MARK: - Initializer

    public init(apiServerPickerConfiguration: ApiServerPickerConfiguration) {
        self.serverCollection = apiServerPickerConfiguration.serversCollections
        self.onServerChange = apiServerPickerConfiguration.onSelectedServerChange

        if let userDefaults {
            if let customServers = try? userDefaults.getObject(forKey: "CustomServers", castTo: [ApiServer].self) {
                self.customServers = customServers
            }

            if let selectedServerName = try? userDefaults.getObject(forKey: serverCollection.name, castTo: String.self) {
                self.selectedServerName = selectedServerName
            }
        }
    }

    // MARK: - Methods

    public func addCustomServer(customServerUrlString: String, customName: String, collectionName: String) throws {
        guard !customServers.contains(where: { $0.name == customName }) else {
            throw CustomServerError.repeatedName
        }

        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", "^https://[A-Za-z0-9.-]{2,}\\.[A-Za-z]{2,}(?:/[^\\s]*)?$")
        if urlPredicate.evaluate(with: customServerUrlString) {
            let customServer = ApiServer(name: customName, url: customServerUrlString)
            customServers.append(customServer)
            saveToUserDefaults(customServers, key: "CustomServers")
        } else {
            throw CustomServerError.invalidUrl
        }
    }

    public func getSelectedServer() -> ApiServer {
        if let selectedServer = serverCollection.servers.first(where: { $0.name == selectedServerName }) {
            return selectedServer
        } else if let selectedServer = customServers.first(where: { $0.name == selectedServerName }){
            return selectedServer
        }

        return serverCollection.defaultServer
    }

    public func deleteCustomServer(_ customServer: ApiServer) {
        customServers.removeAll(where: { $0.name == customServer.name })
        saveToUserDefaults(customServers, key: "CustomServers")
    }

    public func setSelectedServer(_ server: ApiServer) {
        self.selectedServerName = server.name
        saveToUserDefaults(server.name, key: serverCollection.name)
    }

    private func saveToUserDefaults(_ object: Encodable, key: String) {
        do {
            try userDefaults?.setObject(object, forKey: key)
        } catch {
            print(error)
        }
    }

}

extension DebugSelectableServerProvider: BaseUrlProviding {

    public func resolveBaseUrl() async -> String? { getSelectedServer().url }

}

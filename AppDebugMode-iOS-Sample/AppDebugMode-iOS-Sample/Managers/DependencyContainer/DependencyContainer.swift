//
//  DependencyContainer.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Foundation

protocol WithRequestManager: AnyObject {

    var requestManager: RequestManagerType { get }

}

protocol WithCacheManager: AnyObject {
    
    var cacheManager: CacheManagerType { get }
    
}

final class DependencyContainer: WithRequestManager, WithCacheManager {

    lazy var requestManager: RequestManagerType = RequestManager(baseServer: .base)
    lazy var cacheManager: CacheManagerType = CacheManager()

}

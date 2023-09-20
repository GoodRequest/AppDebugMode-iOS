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

final class DependencyContainer: WithRequestManager {

    lazy var requestManager: RequestManagerType = RequestManager(baseServer: .base)

}

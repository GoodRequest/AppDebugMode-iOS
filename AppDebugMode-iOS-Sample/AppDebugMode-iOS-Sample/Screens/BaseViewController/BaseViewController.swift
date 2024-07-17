//
//  BaseViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit
import Combine
import LifetimeTracker

class BaseViewController<T>: UIViewController {
    
    class var lifetimeConfiguration: LifetimeConfiguration {
         return LifetimeConfiguration(maxCount: 1, groupName: "VC")
     }

    let viewModel: T
    var cancellables = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)

        trackLifetime()
    }
    
}

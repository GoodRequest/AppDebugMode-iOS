//
//  BasicButton.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit

class BasicButton: UIButton {

    // MARK: - Constants
    
    private enum C {
        
        static let height = 44.0
        static let edgeInset = 8.0
        
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private

private extension BasicButton {
    
    func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: C.height).isActive = true
        
        setupAppearance()
    }
    
    func setupAppearance() {
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        setTitleColor(.white, for: .normal)
        backgroundColor = .black
        layer.cornerRadius = 8
    }

}

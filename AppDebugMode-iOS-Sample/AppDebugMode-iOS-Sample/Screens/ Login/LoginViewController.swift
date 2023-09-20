//
//  LoginViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit
import Combine
#if DEBUG
import AppDebugMode
#endif

final class LoginViewController: BaseViewController<LoginViewModel> {
    
    // MARK: - Constants
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let loginNameTextView: InputTextFieldView = {
        let textView = InputTextFieldView()
        textView.configure(
            with: InputTextFieldView.Model(
                title: Constants.Texts.Login.loginTitle,
                placeholder: Constants.Texts.Login.loginPlaceholder
            )
        )
        
        return textView
    }()
    
    private let passwordNameTextView: InputTextFieldView = {
        let textView = InputTextFieldView()
        textView.configure(
            with: InputTextFieldView.Model(
                title: Constants.Texts.Login.passwordTitle,
                placeholder: Constants.Texts.Login.passwordPlaceholder
            )
        )
        
        return textView
    }()
    
}

// MARK: - Lifecycle

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        #if DEBUG
        AppDebugModeProvider.shared.selectedTestingUserPublisher
            .sink { [weak self] in
                self?.loginNameTextView.set(text: $0?.name)
                self?.passwordNameTextView.set(text: $0?.password)
            }
            .store(in: &cancellables)
        #endif
    }
    
}

// MARK: - Setup

private extension LoginViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(stackView)
        [loginNameTextView, passwordNameTextView].forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Insets.edgeInset * 2),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Insets.edgeInset * 2)
        ])
    }
    
}

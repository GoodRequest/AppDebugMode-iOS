//
//  HomeViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit
import Security

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    // MARK: - Constants
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.Texts.Home.description
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        
        return label
    }()
    
    private let fetchModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle(Constants.Texts.Home.fetch, for: .normal)

        return button
    }()
    
    private let loginModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle(Constants.Texts.Home.login, for: .normal)
        
        return button
    }()
    
    private let userDefaultsModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle(Constants.Texts.Home.userDefaults, for: .normal)
        
        return button
    }()
    
    private let pushNotificationButton: BasicButton = {
        let button = BasicButton()
        button.setTitle("Send Bistro PUSH notification", for: .normal)
        
        return button
    }()
    
}

// MARK: - Lifecycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        bindAction(viewModel: viewModel)
    }
    
}

// MARK: - Combine

extension HomeViewController {
    
    func bindAction(viewModel: HomeViewModel) {
        fetchModeButton.publisher(for: .touchUpInside)
            .sink { viewModel.goToFetch() }
            .store(in: &cancellables)
        
        loginModeButton.publisher(for: .touchUpInside)
            .sink { viewModel.goToLogin() }
            .store(in: &cancellables)
        
        userDefaultsModeButton.publisher(for: .touchUpInside)
            .sink { viewModel.goToSettings()}
            .store(in: &cancellables)
        
        pushNotificationButton.publisher(for: .touchUpInside)
            .sink { viewModel.send(from: self) }
            .store(in: &cancellables)
    }
    
}

// MARK: - Setup

private extension HomeViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.Texts.Home.title
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        [descriptionLabel, stackView].forEach { view.addSubview($0) }
        [loginModeButton, fetchModeButton, userDefaultsModeButton, pushNotificationButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Insets.edgeInset / 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Insets.edgeInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Insets.edgeInset),
            
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Insets.edgeInset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Insets.edgeInset),
        ])
    }
    
}

extension HomeViewController: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let certificateURL = Bundle.main.url(forResource: "cert", withExtension: "cer"),
              let certificateData = try? Data(contentsOf: certificateURL)
        else {
            print("error loading cert file")
            return
        }
        guard let keyURL = Bundle.main.url(forResource: "key", withExtension: "pem"),
              let keyData = try? Data(contentsOf: keyURL)
        else {
            print("error loading key file")
            return
        }
        
        if let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
            var options: [CFString: Any] = [:]
            options[kSecImportExportPassphrase] = "1234"
            
            var items: CFArray?
            let securityError = SecPKCS12Import(keyData as CFData, options as CFDictionary, &items)
            
            guard securityError == errSecSuccess,
                  let array = items as? [[String: Any]],
                  let identity = array.first?[kSecImportItemIdentity as String] else {
                print("Error creating SecIdentity")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
               }
               
            let credential = URLCredential(identity: identity as! SecIdentity, certificates: [certificate], persistence: .forSession)
            completionHandler(.useCredential, credential)
        }
        
    }
    
}

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
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let p12URL = documentsURL.appendingPathComponent("bisAPNS.p12")
        
        guard fileManager.fileExists(atPath: p12URL.path) else {
            print("Error: .p12 file not found in Documents directory.")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        do {
            let p12Data = try Data(contentsOf: p12URL)
            
            let importPasswordOption: NSDictionary = [kSecImportExportPassphrase as NSString: "123456789"]
            var items: CFArray?
            let securityError = SecPKCS12Import(p12Data as NSData, importPasswordOption, &items)
            
            guard securityError == errSecSuccess else {
                print("Error importing .p12 file: \(securityError)")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            guard let array = items as? [[String: Any]],
                  let identity = array.first?[kSecImportItemIdentity as String] else {
                print("Error extracting identity from .p12 file")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            
            let credential = URLCredential(identity: identity as! SecIdentity, certificates: nil, persistence: .forSession)
            completionHandler(.useCredential, credential)
            
        } catch {
            print("Error loading .p12 file data: \(error.localizedDescription)")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    
}

//
//  HomeViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import AppDebugMode
import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: HomeViewModel

    // MARK: - Initializer

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components

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
        label.text = "...allows an iOS application to select an API Server and User for the app during runtime"
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        return label
    }()

    private let userLoginModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle("User Login Mode", for: .normal)

        return button
    }()
    
    private let apiServerModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle("API Server Mode", for: .normal)

        return button
    }()

    private let userProfileModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle("User Profile Mode", for: .normal)

        return button
    }()

    private let openAppDebugModeButton: BasicButton = {
        let button = BasicButton()
        button.setTitle("Open App Debug Mode", for: .normal)
        return button
    }()

}

// MARK: - Lifecycle

extension HomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        bindActions()

        setupLayout()
    }

}

// MARK: - Binding

extension HomeViewController {

    func bindActions() {
        userLoginModeButton.addTarget(self, action: #selector(userLoginModeButtonClicked), for: .touchUpInside)
        apiServerModeButton.addTarget(self, action: #selector(apiServerModeButtonClicked), for: .touchUpInside)
        userProfileModeButton.addTarget(self, action: #selector(userProfileModeButtonClicked), for: .touchUpInside)
        #if DEBUG
        openAppDebugModeButton.addTarget(self, action: #selector(openAppDebugModeButtonClicked), for: .touchUpInside)
        #endif
    }

    @objc func userLoginModeButtonClicked(_ sender: UIButton) {
       Task {
           await viewModel.goToUserLoginMode()
       }
    }

    @objc func apiServerModeButtonClicked(_ sender: UIButton) {
       Task {
           await viewModel.goToAPIServerMode()
       }
    }

    @objc func userProfileModeButtonClicked(_ sender: UIButton) {
       Task {
           await viewModel.goToUserProfileMode()
       }
    }

    #if DEBUG
    @objc func openAppDebugModeButtonClicked(_ sender: UIButton) {
       Task {
           self.present(await AppDebugMode.PackageManager.shared.start(), animated: true)
       }
    }
    #endif

}

// MARK: - Setup

private extension HomeViewController {

    func setupLayout() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "App Debug Mode"

        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        [descriptionLabel, stackView].forEach { view.addSubview($0) }
        [userLoginModeButton, apiServerModeButton, userProfileModeButton, openAppDebugModeButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16 / 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

}

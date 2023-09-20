//
//  HomeViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    // MARK: - Constants
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
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
        [loginModeButton, fetchModeButton].forEach { stackView.addArrangedSubview($0) }
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

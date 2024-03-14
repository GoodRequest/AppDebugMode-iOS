//
//  HomeViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import UIKit
import Combine

final class FetchViewController: BaseViewController<FetchViewModel> {
    
    // MARK: - Constants
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 32
        
        return stackView
    }()
    
    private let serverLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    private let responseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let fetchButton: FetchButton = {
        let button = FetchButton()
        button.setTitle(Constants.Texts.Fetch.fetch, for: .normal)

        return button
    }()

    private let fetchLarge: FetchButton = {
        let button = FetchButton()
        button.setTitle(Constants.Texts.Fetch.fetchLarge, for: .normal)

        return button
    }()

}

// MARK: - Lifecycle

extension FetchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLayout()
        serverLabel.text = "\(viewModel.selectedServerName): \(viewModel.selectedServerURL)"
        
        bindState(viewModel: viewModel)
        bindActions(viewModel: viewModel)
    }
    
}

// MARK: - Combine

extension FetchViewController {
    
    func bindState(viewModel: FetchViewModel) {
        viewModel.carResult
            .sink { [weak self] in self?.handle(carResult: $0) }
            .store(in: &cancellables)
        
        viewModel.productResult
            .sink { [weak self] in self?.handle(productResult: $0) }
            .store(in: &cancellables)

        viewModel.largeResult
            .sink { [weak self] in self?.handle(largeResult: $0) }
            .store(in: &cancellables)
    }
    
    func bindActions(viewModel: FetchViewModel) {
        fetchButton.publisher(for: .touchUpInside)
            .sink { viewModel.fetchResponse() }
            .store(in: &cancellables)

        fetchLarge.publisher(for: .touchUpInside)
            .sink { viewModel.fetchLarge() }
            .store(in: &cancellables)
    }
    
}

// MARK: - Setup

private extension FetchViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.Texts.Home.fetch
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        [responseLabel, serverLabel].forEach { stackView.addArrangedSubview($0) }
        [stackView, fetchButton, fetchLarge].forEach { view.addSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            fetchButton.topAnchor.constraint(equalTo: fetchLarge.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            fetchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Insets.edgeInset * 2),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchLarge.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.bottomAnchor.constraint(lessThanOrEqualTo: fetchButton.topAnchor, constant: -Constants.Insets.edgeInset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Insets.edgeInset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Insets.edgeInset),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}

// MARK: - Handle

private extension FetchViewController {
    
    func handle(carResult: FetchViewModel.CarFetchingState) {
        switch carResult {
        case .idle:
            responseLabel.text = Constants.Texts.Fetch.placeHolder
        case .loading:
            fetchButton.isLoading = true
        case .success(let carResponse):
            guard let data = try? JSONEncoder().encode(carResponse) else { return }

            fetchButton.isLoading = false
            responseLabel.text = String(data: data, encoding: .utf8)
        case .error(_):
            responseLabel.text = nil
            fetchButton.isLoading = false
        }
    }
    
    func handle(productResult: FetchViewModel.ProductFetchingState) {
        switch productResult {
        case .idle:
            responseLabel.text = Constants.Texts.Fetch.placeHolder
        case .loading:
            fetchButton.isLoading = true
        case .success(let productResponse):
            guard let data = try? JSONEncoder().encode(productResponse) else { return }

            fetchButton.isLoading = false
            responseLabel.text = String(data: data, encoding: .utf8)
        case .error(_):
            responseLabel.text = nil
            fetchButton.isLoading = false
        }
    }

    func handle(largeResult: FetchViewModel.LargeFetchingState) {
        switch largeResult {
        case .idle:
            responseLabel.text = Constants.Texts.Fetch.placeHolder
        case .loading:
            fetchLarge.isLoading = true

        case .success(let largeResponse):
            guard let data = try? JSONEncoder().encode(largeResponse) else { return }

            fetchLarge.isLoading = false

            responseLabel.text = String(data: data, encoding: .utf8)
        case .error(_):
            responseLabel.text = nil
            fetchLarge.isLoading = false
        }
    }

}

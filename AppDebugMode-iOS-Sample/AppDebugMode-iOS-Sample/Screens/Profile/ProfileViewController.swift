//
//  SettingsViewController.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 25/09/2023.
//

import UIKit

final class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    // MARK: - Constants
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let fullNameTextView: InputTextFieldView = {
        let textView = InputTextFieldView()
        textView.configure(
            with: InputTextFieldView.Model(
                title: Constants.Texts.Profile.nameTitle,
                placeholder: Constants.Texts.Profile.namePlaceholder
            )
        )
        
        return textView
    }()
    
    private let genderControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Constants.Texts.Profile.genderOptions)
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
}

// MARK: - Lifecycle

extension ProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameTextView.textField.text = viewModel.loadFullName()
        genderControl.selectedSegmentIndex = viewModel.loadGender()
        
        setupLayout()
        
        bindActions(viewModel: viewModel)
    }
    
}

// MARK: - Selectors

extension ProfileViewController {
    
    @objc func saveTapped(_ sender: UIButton) {
        viewModel.saveUserData()
    }
    
}

// MARK: - Combine

extension ProfileViewController {
    
    func bindActions(viewModel: ProfileViewModel) {
        fullNameTextView.textField.publisher(for: .editingChanged)
            .sink { [weak self] _ in viewModel.fullName = self?.fullNameTextView.textField.text ?? "" }
            .store(in: &cancellables)
        
        genderControl.publisher(for: .valueChanged)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                viewModel.gender = self.genderControl.selectedSegmentIndex
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - Private

private extension ProfileViewController {
    
    func setupLayout() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Constants.Texts.Home.userDefaults
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped(_:)))
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(stackView)
        [fullNameTextView, genderControl].forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Insets.edgeInset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Insets.edgeInset)
        ])
    }
    
}

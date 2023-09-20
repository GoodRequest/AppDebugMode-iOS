//
//  InputTextFieldView.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 20/09/2023.
//

import UIKit

final class InputTextFieldView: UIView {
    
    // MARK: - Model
    
    struct Model {
        
        let title: String
        let placeholder: String
        
    }
    
    // MARK: - Constants
    
    enum C {
        
        static let textFieldHeight = 44.0
        static let textFieldInset = 8.0
        
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        
        return textField
    }()
    
    // MARK: - Variables - Computed
    
    private var insetView: UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: C.textFieldInset, height: 0))
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }
    
}

// MARK: - Public

extension InputTextFieldView {
    
    func configure(with model: Model) {
        textField.placeholder = model.placeholder
        titleLabel.text = model.title.uppercased()
    }
    
    func set(text: String?) {
        textField.text = text
    }
    
}

// MARK: - Private

private extension InputTextFieldView {
    
    func setupLayout() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(stackView)
        [titleLabel, textField].forEach { stackView.addArrangedSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: C.textFieldHeight),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupTextField() {
        textField.leftView = insetView
        textField.rightView = insetView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
    }
    
}

//
//  FetchButton.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 19/09/2023.
//

import UIKit

class FetchButton: UIButton {
    
    // MARK: - Constants
    
    private enum C {
        
        static let height = 44.0
        
    }
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    // MARK: - Variables
    
    private var title: String?
    
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            
            isLoading ? startLoading() : stopLoading()
            isUserInteractionEnabled = !isLoading
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else { return }
            
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction],
                animations: { [weak self] in
                    guard let self = self else { return }
                    
                    self.alpha = self.isHighlighted ? 0.5 : 1
                },
                completion: nil
            )
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configuration = .bordered()

        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private

private extension FetchButton {
    
    func setupLayout() {
        addSubview(activityIndicatorView)
        setupConstraints()
        setupAppearance()
    }
    
    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor)
        ])
    }
    
    func setupAppearance() {
        heightAnchor.constraint(equalToConstant: C.height).isActive = true
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = C.height / 2
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
    }
    
    func startLoading() {
        title = title(for: .normal)
        setTitle(nil, for: .normal)
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        setTitle(title, for: .normal)
        activityIndicatorView.stopAnimating()
    }
    
}

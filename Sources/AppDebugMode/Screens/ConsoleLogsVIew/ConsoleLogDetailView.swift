//
//  ConsoleLogDetailViewController.swift
//
//
//  Created by Matus Klasovity on 31/01/2024.
//

import UIKit

class ConsoleLogDetailViewController: UIViewController {
    
    // MARK: - Views
    
    let copyButton: UIButton = {
        var button = UIButton()
        button.setTitle("Copy", for: .normal)
        button.setTitleColor(UIColor(cgColor: AppDebugColors.primary.cgColor!), for: .normal)
        button.setTitleColor(UIColor(cgColor: AppDebugColors.primary.opacity(0.5).cgColor!), for: .highlighted)
        return button
    }()
    
    let detectorButton: UIButton = {
        var button = UIButton()
        button.setTitle("Detect", for: .normal)
        button.setTitleColor(UIColor(cgColor: AppDebugColors.primary.cgColor!), for: .normal)
        button.setTitleColor(UIColor(cgColor: AppDebugColors.primary.opacity(0.5).cgColor!), for: .highlighted)
        return button
    }()
    
    let trailingNavigationView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(AppDebugColors.backgroundSecondary)
        
        textView.textColor = UIColor(AppDebugColors.textPrimary)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        
        return textView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    
    // MARK: - Initialization
    
    init(text: String) {
        textView.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Override

extension ConsoleLogDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
             
        navigationController?.navigationBar.configureSolidAppearance()

        setupView()
        setupConstraints()
    }
}

// MARK: - Setup View

private extension ConsoleLogDetailViewController {
    
    func setupView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: trailingNavigationView)
        
        view.backgroundColor = UIColor(AppDebugColors.backgroundSecondary)
        view.addSubview(scrollView)
        
        detectorButton.addTarget(self, action: #selector(detectorButtonClicked), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyButtonClicked), for: .touchUpInside)
        [detectorButton, copyButton].forEach { trailingNavigationView.addArrangedSubview($0) }
       
        scrollView.addSubview(textView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
}

// MARK: - Actions

private extension ConsoleLogDetailViewController {
    
    @IBAction func copyButtonClicked(_ sender: Any?) {
        UIPasteboard.general.string = textView.text
    }
    
    @IBAction func detectorButtonClicked(_ sender: Any?) {
        textView.dataDetectorTypes = .all
    }
    
}

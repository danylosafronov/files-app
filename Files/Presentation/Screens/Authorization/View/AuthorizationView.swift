//
//  AuthorizationView.swift
//  Files
//
//  Created by Danylo Safronov on 17.06.2022.
//

import Foundation
import GoogleSignIn
import UIKit

final class AuthorizationView: UIView {
    private lazy var backgroundView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var signInWithGoogleButton = GIDSignInButton()
    private lazy var contentStackView = UIStackView()
    private lazy var contentLayoutGuide = UILayoutGuide()
    
    weak var delegate: AuthorizationViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureContentLayoutGuide()
        configureBackgroundView()
        configureContentStackView()
        configureTitleLabel()
        configureSignInWithGoogleButton()
    }
    
    private func configureContentLayoutGuide() {
        addLayoutGuide(contentLayoutGuide)
        
        let constraints = [
            contentLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureBackgroundView() {
        addSubview(backgroundView)
        
        backgroundView.backgroundColor = .systemBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            backgroundView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureContentStackView() {
        addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 8.0
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            contentStackView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureTitleLabel() {
        contentStackView.addArrangedSubview(titleLabel)
        
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
        titleLabel.text = "Sign in with your Google account"
    }
    
    private func configureSignInWithGoogleButton() {
        contentStackView.addArrangedSubview(signInWithGoogleButton)
        signInWithGoogleButton.addTarget(self, action: #selector(didTapSignInWithGoogleButton), for: .touchUpInside)
    }
    
    // MARK: - Events
    
    @objc
    private func didTapSignInWithGoogleButton() {
        delegate?.didTapSignInWithGoogleButton()
    }
}

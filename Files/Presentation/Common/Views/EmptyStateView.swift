//
//  EmptyStateView.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation
import UIKit

final class EmptyStateView: UIView {
    private lazy var label = UILabel()
    private lazy var backgroundView = UIView()
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureBackgroundView()
        configureLabel()
    }
    
    private func configureBackgroundView() {
        addSubview(backgroundView)
        
        backgroundView.backgroundColor = .systemBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureLabel() {
        addSubview(label)
        
        label.text = "No data"
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//
//  FilesystemCardItemCollectionViewCell.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import UIKit

final class FilesystemCardItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "FilesystemCardItemCollectionViewCell"
    
    private lazy var defaultContentView = FilesystemCardItemContentView()

    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        backgroundView?.backgroundColor = .systemBackground
        configureContentView()
    }
    
    private func configureContentView() {
        contentView.addSubview(defaultContentView)
        
        defaultContentView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            defaultContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            defaultContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            defaultContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            defaultContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        defaultContentView.cleanup()
    }
    
    func setup(withViewModel viewModel: FilesystemListItemViewModel) {
        defaultContentView.setup(withModel: viewModel.item)
    }
}

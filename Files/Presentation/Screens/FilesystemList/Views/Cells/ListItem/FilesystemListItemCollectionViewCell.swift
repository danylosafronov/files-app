//
//  FilesystemListItemCollectionViewCell.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import UIKit

final class FilesystemListItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "FilesystemListItemCollectionViewCell"
    
    private lazy var defaultContentView = FilesystemListItemContentView()
    
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

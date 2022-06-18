//
//  FilesystemListItemCollectionViewCell.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import UIKit

final class FilesystemListItemCollectionViewCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
    typealias DeleteActionHandler = () -> Void
    static let identifier = "FilesystemListItemCollectionViewCell"
    
    private lazy var defaultContentView = FilesystemListItemContentView()
    private lazy var interaction = UIContextMenuInteraction(delegate: self)
    
    private var registeredDeleteActionHandler: DeleteActionHandler? = nil
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        defaultContentView.cleanup()
        registeredDeleteActionHandler = nil
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureContentView()
        configureInteraction()
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
    
    private func configureInteraction() {
        addInteraction(interaction)
    }
    
    // MARK: - Actions

    func setup(withViewModel viewModel: FilesystemListItemViewModel, deleteActionHandler: DeleteActionHandler? = nil) {
        defaultContentView.setup(withModel: viewModel.item)
        registeredDeleteActionHandler = deleteActionHandler
    }
    
    // MARK: - UIContextMenuInteractionDelegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let action = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: [.destructive]) { [weak self] action in
                self?.didTapDeleteAction()
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, children:[action])
        }
        
        return configuration
    }
    
    // MARK: - Events
    
    private func didTapDeleteAction() {
        registeredDeleteActionHandler?()
    }
}

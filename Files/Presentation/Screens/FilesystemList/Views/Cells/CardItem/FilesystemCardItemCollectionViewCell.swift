//
//  FilesystemCardItemCollectionViewCell.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import UIKit

final class FilesystemCardItemCollectionViewCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
    static let identifier = "FilesystemCardItemCollectionViewCell"
    typealias DeleteActionHandler = () -> Void

    private lazy var defaultContentView = FilesystemCardItemContentView()
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

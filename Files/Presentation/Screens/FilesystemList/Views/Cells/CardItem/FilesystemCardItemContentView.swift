//
//  FilesystemCardItemContentView.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import UIKit

final class FilesystemCardItemContentView: UIView {
    private lazy var titleLabel = UILabel()
    private lazy var imageView = UIImageView()
    private lazy var contentLayoutGuide = UILayoutGuide()
    
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
        configureImageView()
        configureTitleLabel()
    }
    
    private func configureContentLayoutGuide() {
        addLayoutGuide(contentLayoutGuide)
        
        let constraints = [
            contentLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureImageView() {
        addSubview(imageView)
        
        imageView.image = UIImage(systemName: "folder")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            imageView.widthAnchor.constraint(equalToConstant: 48.0),
            imageView.heightAnchor.constraint(equalToConstant: 48.0),
            imageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        
        titleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam malesuada diam ac risus vehicula suscipit. Nulla suscipit luctus augue, dictum semper sapien fringilla ut."
        titleLabel.font = .systemFont(ofSize: 17.0)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    
    func cleanup() {
        imageView.image = nil
        titleLabel.text = ""
    }
    
    func setup(withModel model: FilesystemItem) {
        titleLabel.text = model.name
        imageView.image = resolveImageViewImage(byFilesystemItemType: model.type)
    }
    
    // MARK: - Logic
    
    private func resolveImageViewImage(byFilesystemItemType type: FilesystemItemType) -> UIImage? {
        UIImage(systemName: type == .directory ? "folder" : "doc")
    }
}

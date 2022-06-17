//
//  FilesystemListItemContentView.swift
//  Files
//
//  Created by Danylo Safronov on 13.06.2022.
//

import UIKit

final class FilesystemListItemContentView: UIView {
    private lazy var titleLabel = UILabel()
    private lazy var leadingImageView = UIImageView()
    private lazy var trailingImageView = UIImageView()
    private lazy var contentLayoutGuide = UILayoutGuide()
    private lazy var separator = UIView()
    
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
        configureLeadingImageView()
        configureTrailingImageView()
        configureTitleLabel()
        configureSeparator()
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
    
    private func configureLeadingImageView() {
        addSubview(leadingImageView)
        
        leadingImageView.image = UIImage(systemName: "folder")
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingImageView.widthAnchor.constraint(equalToConstant: 24.0),
            leadingImageView.heightAnchor.constraint(equalTo: leadingImageView.widthAnchor),
            leadingImageView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            leadingImageView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
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
        
        let constraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingImageView.leadingAnchor, constant: -8.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureTrailingImageView() {
        addSubview(trailingImageView)
        
        trailingImageView.image = UIImage(systemName: "chevron.right")
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            trailingImageView.widthAnchor.constraint(equalToConstant: 20.0),
            trailingImageView.heightAnchor.constraint(equalTo: trailingImageView.widthAnchor),
            trailingImageView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            trailingImageView.centerYAnchor.constraint(equalTo: contentLayoutGuide.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureSeparator() {
        addSubview(separator)
        
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            separator.topAnchor.constraint(equalTo: leadingImageView.bottomAnchor, constant: 8.0),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    
    func cleanup() {
        leadingImageView.image = nil
        trailingImageView.image = nil
        titleLabel.text = ""
    }
    
    func setup(withModel model: FilesystemItem) {
        titleLabel.text = model.name
        leadingImageView.image = resolveLeadingImageViewImage(byFilesystemItemType: model.type)
        trailingImageView.image = resolveTrilingImageViewImage(byFilesystemItemType: model.type)
    }
    
    // MARK: - Logic
    
    private func resolveLeadingImageViewImage(byFilesystemItemType type: FilesystemItemType) -> UIImage? {
        UIImage(systemName: type == .directory ? "folder" : "doc")
    }
    
    private func resolveTrilingImageViewImage(byFilesystemItemType type: FilesystemItemType) -> UIImage? {
        type == .directory ? UIImage(systemName: "chevron.right") : nil
    }
}

extension FilesystemListItemContentView {
    static func height(_ label: String, forWidth width: CGFloat) -> CGFloat {
        var horizontalSpacing = 8.0 * 4 // horizontal paddings
        horizontalSpacing += 24.0 // leading image
        horizontalSpacing += 20.0 // trailing image
        
        let width = width - horizontalSpacing
        
        let leadingImageHeight = 24.0
        let trailingImageHeight = 20.0
        let labelHeight = label.height(forWidth: width, withFont: .systemFont(ofSize: 17.0))
        
        return max(leadingImageHeight, trailingImageHeight, labelHeight) + 8.0 * 2
    }
}

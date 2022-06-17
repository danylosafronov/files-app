//
//  FilesystemListView.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import Combine
import UIKit

final class FilesystemListView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    enum DisplayMode {
        case column
        case grid
    }
    
    private lazy var collectionGridFlowLayout = GridFlowLayout()
    private lazy var collectionColumnFlowLayout = ColumnFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionColumnFlowLayout)
    private lazy var contentLayoutGuide = UILayoutGuide()
    private lazy var loadingView = LoadingView()
    private lazy var emptyStateView = EmptyStateView()
    
    @Published private (set) var mode: DisplayMode = .column
    private var cancellable = Set<AnyCancellable>()
    
    weak var delegate: FilesystemListViewDelegate?
    weak var dataSource: FilesystemListViewDataSource?
    
    init() {
        super.init(frame: .zero)
        configure()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureContentLayoutGuide()
        configureCollectionView()
        configureLoadingView()
        configureEmptyStateView()
    }
    
    private func configureContentLayoutGuide() {
        addLayoutGuide(contentLayoutGuide)
        
        let constraints = [
            contentLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilesystemListItemCollectionViewCell.self, forCellWithReuseIdentifier: FilesystemListItemCollectionViewCell.identifier)
        collectionView.register(FilesystemCardItemCollectionViewCell.self, forCellWithReuseIdentifier: FilesystemCardItemCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureCollectionViewLayout(byMode mode: DisplayMode) {
        let layout = resolveCollectionViewLayout(byMode: mode)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func configureLoadingView() {
        addSubview(loadingView)
        
        loadingView.layer.zPosition = 2
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            loadingView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureEmptyStateView() {
        addSubview(emptyStateView)
        
        emptyStateView.layer.zPosition = 1
        emptyStateView.isHidden = true
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            emptyStateView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Observation
    
    private func observe() {
        observeMode()
    }
    
    private func observeMode() {
        $mode
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] mode in
                self?.didChangeDisplayMode(mode)
            }
            .store(in: &cancellable)
    }
        
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.numberOfItems(inSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resolveCollectionViewReusableCellReuseIdentifier(byMode: mode), for: indexPath)
        
        if let viewModel = dataSource?.item(at: indexPath) {
            switch cell {
            case let cell as FilesystemCardItemCollectionViewCell:
                cell.setup(withViewModel: viewModel)
                
            case let cell as FilesystemListItemCollectionViewCell:
                cell.setup(withViewModel: viewModel)
            
            default:
                fatalError("Unsupported collection view cell")
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath)
    }
    
    // MARK: - Actions :
    
    func setDisplayMode(_ mode: DisplayMode) {
        self.mode = mode
    }
    
    func insertItems(at indexes: [IndexPath]) {
        collectionView.insertItems(at: indexes)
    }
    
    func showLoadingState() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideLoadingState() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func showEmptyState() {
        emptyStateView.isHidden = false
    }
    
    func hideEmptyState() {
        emptyStateView.isHidden = true
    }
    
    // MARK: - Events :
    
    private func didChangeDisplayMode(_ mode: DisplayMode) {
        configureCollectionViewLayout(byMode: mode)
    }
    
    // MARK: - Logic :
    
    private func resolveCollectionViewLayout(byMode mode: DisplayMode) -> UICollectionViewLayout {
        switch mode {
        case .column: return collectionColumnFlowLayout
        case .grid: return collectionGridFlowLayout
        }
    }
    
    private func resolveCollectionViewReusableCellReuseIdentifier(byMode mode: DisplayMode) -> String {
        switch mode {
        case .column: return FilesystemListItemCollectionViewCell.identifier
        case .grid: return FilesystemCardItemCollectionViewCell.identifier
        }
    }
}

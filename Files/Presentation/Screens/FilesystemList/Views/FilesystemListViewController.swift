//
//  FileListViewController.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import Combine
import UIKit

final class FilesystemListViewController: UIViewController, FilesystemListViewDelegate, FilesystemListViewDataSource {
    private enum BarButtonItemTag: Int {
        case changeViewMode = 1
        case createFolder = 2
        case createFile = 3
    }
    
    private enum AlertType {
        case createFolder
        case createFile
    }
    
    private lazy var defaultView = FilesystemListView()
    
    private var viewModel: FilesystemListViewModel
    private var cancellable = Set<AnyCancellable>()
    
    weak var delegate: FilesystemListViewControllerDelegate?
    
    init(viewModel: FilesystemListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func loadView() {
        super.loadView()
        
        defaultView.delegate = self
        defaultView.dataSource = self
        view = defaultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        observe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isMovingToParent {
            viewModel.load()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            viewModel.stop()
        }
    }
    
    // MARK: - Configurations
    
    private func configure() {
        configureNavigationBar()
        configureNavigationBarItems()
    }
    
    private func configureNavigationBar() {
        configureNavigationBarTitle(viewModel.parent?.name ?? "Browse")
    }
    
    private func configureNavigationBarTitle(_ title: String) {
        navigationItem.title = title
    }
    
    private func configureNavigationBarItems() {
        navigationItem.rightBarButtonItems = [
            makeChangeViewModeBarButtonItem(mode: defaultView.mode),
//            makeCreateFolderBarButtonItem(),
//            makeCreateFileBarButtonItem(),
        ]
    }
    
    // MARK: - Observers
    
    private func observe() {
        observeContentViewDisplayMode()
        observeViewModelItems()
        observeViewModelParent()
        observeViewModelLoading()
    }
    
    private func observeContentViewDisplayMode() {
        defaultView.$mode
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.didChangeContentViewDisplayMode(mode)
            }
            .store(in: &cancellable)
    }
    
    private func observeViewModelItems() {
        viewModel.$items
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.didChangeViewModelItems(items)
            }
            .store(in: &cancellable)
    }
    
    private func observeViewModelParent() {
        viewModel.$parent
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] parent in
                self?.didChangeViewModelParent(parent)
            }
            .store(in: &cancellable)
    }
    
    private func observeViewModelLoading() {
        viewModel.$loading
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] state in
                self?.didChangeViewModelLoading(state)
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Events
    
    @objc
    private func didTapModeBarButtonItem() {
        defaultView.setDisplayMode(defaultView.mode == .column ? .grid : .column)
    }
    
    @objc
    private func didTapCreateFolderBarButtonItem() {
        present(makeAlert(ofType: .createFolder), animated: true)
    }
    
    @objc
    private func didTapCreateFileBarButtonItem() {
        present(makeAlert(ofType: .createFile), animated: true)
    }
    
    private func didChangeContentViewDisplayMode(_ mode: FilesystemListView.DisplayMode) {
        guard let items = navigationItem.rightBarButtonItems,
              let modeBarButtonItem = items.first(where: { $0.tag == BarButtonItemTag.changeViewMode.rawValue })
        else {
            return
        }
        
        let systemName = resolveModeBarButtonItemIconSystemName(byMode: mode)
        modeBarButtonItem.image = UIImage(systemName: systemName)
    }
    
    private func didChangeViewModelItems(_ items: [FilesystemListItemViewModel]) {
        guard !items.isEmpty else {
            defaultView.showEmptyState()
            return
        }
        
        defaultView.hideEmptyState()
        defaultView.insertItems(at: viewModel.indexes(forItems: items))
    }
    
    private func didChangeViewModelParent(_ parent: FilesystemItem?) {
        let title = parent?.name ?? "Browse"
        configureNavigationBarTitle(title)
    }
    
    private func didChangeViewModelLoading(_ state: Bool) {
        state ? defaultView.showLoadingState() : defaultView.hideLoadingState()
    }
    
    private func didTapAlertCreateItem(_ alert: UIAlertController, ofType type: AlertType, withName name: String) {
        // todo
    }
    
    // MARK: - FilesystemListViewDelegate
    
    func didSelectItem(at index: IndexPath) {
        guard let viewModel = viewModel.item(at: index) else { return }
        delegate?.didSelectItem(viewModel.item)
    }
    
    // MARK: - FilesystemListViewDataSource
    
    func numberOfItems(inSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func item(at index: IndexPath) -> FilesystemListItemViewModel? {
        viewModel.item(at: index)
    }
    
    // MARK: Logic
    
    private func makeChangeViewModeBarButtonItem(mode: FilesystemListView.DisplayMode) -> UIBarButtonItem {
        let systemName = resolveModeBarButtonItemIconSystemName(byMode: mode)
        let item = UIBarButtonItem(image: UIImage(systemName: systemName), style: .plain, target: self, action: #selector(didTapModeBarButtonItem))
        item.tag = BarButtonItemTag.changeViewMode.rawValue
        
        return item
    }
    
    private func makeCreateFolderBarButtonItem() -> UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(didTapCreateFolderBarButtonItem))
        item.tag = BarButtonItemTag.createFolder.rawValue
        
        return item
    }
    
    private func makeCreateFileBarButtonItem() -> UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(didTapCreateFileBarButtonItem))
        item.tag = BarButtonItemTag.createFile.rawValue
        
        return item
    }
    
    private func resolveModeBarButtonItemIconSystemName(byMode mode: FilesystemListView.DisplayMode) -> String {
        mode == .column ? "rectangle.grid.3x2.fill" : "rectangle.grid.1x2.fill"
    }
    
    private func makeAlert(ofType type: AlertType) -> UIAlertController {
        let alertTitle = resolveAlertTitle(byType: type)
        let alertMessage = resolveAlertMessage(byType: type)
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .destructive))
        
        configureAlert(alert, byType: type)
        return alert
    }
    
    private func resolveAlertTitle(byType type: AlertType) -> String {
        switch type {
        case .createFolder: return "Create a new folder"
        case .createFile: return "Create a new file"
        }
    }
    
    private func resolveAlertMessage(byType type: AlertType) -> String {
        switch type {
        case .createFolder: return "Enter a folder name"
        case .createFile: return "Enter a file name"
        }
    }
    
    private func configureAlert(_ alert: UIAlertController, byType type: AlertType) {
        switch type {
        case .createFolder, .createFile:
            alert.addTextField()
            alert.addAction(.init(title: "Create", style: .default) { [weak self, weak alert] _ in
                guard let self = self,
                      let alert = alert,
                      let textFields = alert.textFields,
                      let textField = textFields.first,
                      let text = textField.text
                else {
                    return
                }
                
                self.didTapAlertCreateItem(alert, ofType: type, withName: text)
            })
        }
    }
}

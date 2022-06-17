//
//  FilesystemListViewModel.swift
//  Files
//
//  Created by Danylo Safronov on 13.06.2022.
//

import Foundation

final class FilesystemListViewModel {
    @Published private (set) var parent: FilesystemItem?
    @Published private (set) var items: [FilesystemListItemViewModel] = []
    @Published private (set) var loading: Bool = false
    
    private let getFilesystemItemsUseCase: GetFilesystemItemsUseCase
    private let saveFilesystemItemUseCase: SaveFilesystemItemUseCase
    private let deleteFilesystemItemUseCase: DeleteFilesystemItemUseCase
    
    private var loadItemsTask: Task<Void, Error>? {
        willSet { cancelTask(loadItemsTask) }
    }
    
    private var createItemTask: Task<Void, Error>? {
        willSet { cancelTask(createItemTask) }
    }
    
    init(parent: FilesystemItem? = nil,
         getFilesystemItemsUseCase: GetFilesystemItemsUseCase,
         saveFilesystemItemUseCase: SaveFilesystemItemUseCase,
         deleteFilesystemItemUseCase: DeleteFilesystemItemUseCase) {
        self.parent = parent
        self.getFilesystemItemsUseCase = getFilesystemItemsUseCase
        self.saveFilesystemItemUseCase = saveFilesystemItemUseCase
        self.deleteFilesystemItemUseCase = deleteFilesystemItemUseCase
    }
    
    deinit {
        cancelTask(loadItemsTask)
        cancelTask(createItemTask)
    }
    
    // MARK: - Logic
    
    func load() {
        loadItems(forParent: parent?.id)
    }
    
    func stop() {
        loadItemsTask = nil
        createItemTask = nil
    }
    
    func indexes(forItems items: [FilesystemListItemViewModel]) -> [IndexPath] {
        items.compactMap { item in
            guard let index = self.items.firstIndex(where: { $0.id == item.id }) else {
                return nil
            }
            
            return IndexPath(row: index, section: 0)
        }
    }
    
    func item(at indexPath: IndexPath) -> FilesystemListItemViewModel? {
        let index = indexPath.row
        guard items.indices.contains(index) else {
            return nil
        }
        
        return items[index]
    }
    
    private func loadItems(forParent parentId: String?) {
        loading = true
        
        loadItemsTask = Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            await self.loadItemsAsync(forParent: parentId)
            
            loading = false
            loadItemsTask = nil
        }
    }
    
    private func loadItemsAsync(forParent parentId: String?) async {
        guard !Task.isCancelled else { return }
        
        do {
            let items = try await getFilesystemItemsUseCase.invoke(parentId: parentId)
                .sorted { first, _ in first.type == .directory }
            
            guard !Task.isCancelled else { return }
            
            let viewModels = items.map { item in
                FilesystemListItemViewModel(item: item)
            }
            
            guard !Task.isCancelled else { return }
            self.items = viewModels
        } catch {
            print(error)
        }
    }
    
    func createItem(_ type: FilesystemItemType, withName name: String) {
        loading = true
        
        createItemTask = Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            await self.createItemAsync(type, withName: name)
            
            loading = false
            createItemTask = nil
        }
    }
    
    private func createItemAsync(_ type: FilesystemItemType, withName name: String) async {
        guard !Task.isCancelled else { return }
        
        do {
            let item = FilesystemItem(id: UUID().uuidString,
                                      parentId: parent?.id,
                                      type: type,
                                      name: name)
            
            try await saveFilesystemItemUseCase.invoke(item: item)
            
            guard !Task.isCancelled else { return }
            await loadItemsAsync(forParent: parent?.id)
        } catch {
            print(error)
        }
    }
    
    private func cancelTask<Success, Failure>(_ task: Task<Success, Failure>?) {
        if let task = task, !task.isCancelled {
            task.cancel()
        }
    }
}

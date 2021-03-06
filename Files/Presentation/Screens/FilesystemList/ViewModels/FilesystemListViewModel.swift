//
//  FilesystemListViewModel.swift
//  Files
//
//  Created by Danylo Safronov on 13.06.2022.
//

import Foundation

@MainActor final class FilesystemListViewModel {
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
    
    private var deleteItemTask: Task<Void, Error>? {
        willSet { cancelTask(deleteItemTask) }
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

    // MARK: - Logic
    
    func load() {
        loadItems(forParent: parent?.id)
    }
    
    func stop() {
        loadItemsTask = nil
        createItemTask = nil
        deleteItemTask = nil
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
        loadItemsTask = Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            self.loading = true
            
            await self.loadItemsAsync(forParent: parentId)
            
            self.loading = false
            self.loadItemsTask = nil
        }
    }
    
    private func loadItemsAsync(forParent parentId: String?) async {
        guard !Task.isCancelled else { return }
        
        do {
            let filesystemItems = try await getFilesystemItemsUseCase.invoke(parentId: parentId)

            guard !Task.isCancelled else { return }
            let viewModels = filesystemItems.map { item in
                FilesystemListItemViewModel(item: item)
            }
            
            guard !Task.isCancelled else { return }
            items = viewModels
        } catch {
            print(error)
        }
    }
    
    func createItem(_ type: FilesystemItemType, withName name: String) {
        createItemTask = Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            self.loading = true
            
            await self.createItemAsync(type, withName: name)
            
            if !Task.isCancelled {
                await loadItemsAsync(forParent: parent?.id)
            }
            
            self.loading = false
            self.createItemTask = nil
        }
    }
    
    private func createItemAsync(_ type: FilesystemItemType, withName name: String) async {
        guard !Task.isCancelled else { return }
        
        do {
            try await saveFilesystemItemUseCase.invoke(
                item: FilesystemItem(
                    id: UUID().uuidString,
                    index: items.count + 1,
                    parentId: parent?.id,
                    type: type,
                    name: name
                )
            )
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: FilesystemItem) {
        deleteItemTask = Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            self.loading = true
            
            await self.deleteItemAsync(item)
            
            if !Task.isCancelled {
                await loadItemsAsync(forParent: parent?.id)
            }
            
            self.loading = false
            self.deleteItemTask = nil
        }
    }
    
    private func deleteItemAsync(_ item: FilesystemItem) async {
        guard !Task.isCancelled else { return }
        
        do {
            try await deleteFilesystemItemUseCase.invoke(item: item)
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

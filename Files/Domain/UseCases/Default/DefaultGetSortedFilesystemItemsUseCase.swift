//
//  DefaultGetSortedFilesystemItemsUseCase.swift
//  Files
//
//  Created by Danylo Safronov on 29.06.2022.
//

import Foundation

struct DefaultGetSortedFilesystemItemsUseCase: GetSortedFilesystemItemsUseCase {
    let getFilesystemItemsUseCase: GetFilesystemItemsUseCase
    
    func invoke(parentId: String?) async throws -> [FilesystemItem] {
        let items = try await getFilesystemItemsUseCase.invoke(parentId: parentId)
        let sortedItems = sortFilesystemItems(items: items)
        
        return sortedItems
    }
    
    private func sortFilesystemItems(items: [FilesystemItem]) -> [FilesystemItem] {
        var dirictories: [FilesystemItem] = []
        var files: [FilesystemItem] = []
        
        items.forEach { item in
            item.type == .directory ? dirictories.append(item) : files.append(item)
        }
        
        dirictories = dirictories.sorted { $0.name.lowercased() < $1.name.lowercased() }
        files = files.sorted { $0.name.lowercased() < $1.name.lowercased() }
        
        return dirictories + files
    }
}

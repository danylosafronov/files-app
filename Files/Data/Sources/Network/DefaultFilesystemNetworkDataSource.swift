//
//  DefaultFilesystemNetworkDataSource.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

struct DefaultFilesystemNetworkDataSource: FilesystemNetworkDataSource {
    let sheetId: String
    let service: GSheetsService
    
    func items(forParent parentId: String?) async throws -> [FilesystemItem] {
        try await service.fetch(fromSpreadsheet: sheetId)
            .rows
            .enumerated()
            .compactMap { index, row in
                guard
                    let id = row.getOrNil(index: 0),
                    let parentId = row.getOrNil(index: 1),
                    let type = row.getOrNil(index: 2),
                    let name = row.getOrNil(index: 3)
                else {
                    return nil
                }
                
                guard let type = FilesystemItemType(rawValue: type) else {
                    return nil
                }
                
                return FilesystemItem(id: id,
                                      index: index,
                                      parentId: parentId.isEmpty ? nil : parentId,
                                      type: type,
                                      name: name)
            }
            .filter { $0.parentId == parentId }
    }
    
    func insert(item: FilesystemItem) async throws {
        try await service.insert([item.id, item.parentId ?? "", item.type.rawValue, item.name], at: item.index + 1, toSpreadsheet: sheetId)
    }
    
    func delete(item: FilesystemItem) async throws {
        try await service.delete(at: item.index + 1, fromSpreadsheet: sheetId)
    }
}

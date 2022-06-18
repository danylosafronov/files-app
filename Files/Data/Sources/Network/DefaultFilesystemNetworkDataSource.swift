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
        try await service.fetch(sheetId: sheetId)
            .rows
            .map { row in
                guard
                    let id = row.getOrNil(index: 0),
                    let parentId = row.getOrNil(index: 1),
                    let type = row.getOrNil(index: 2),
                    let name = row.getOrNil(index: 3)
                else {
                    throw DefaultFilesystemNetworkDataSourceError.invalidRowFormat
                }
                
                guard let type = FilesystemItemType(rawValue: type) else {
                    throw DefaultFilesystemNetworkDataSourceError.invalidRowType
                }
                
                return FilesystemItem(id: id,
                                      parentId: parentId.isEmpty ? nil : parentId,
                                      type: type,
                                      name: name)
            }
            .filter { $0.parentId == parentId }
    }
    
    func insert(item: FilesystemItem) async throws {
        try await service.insert(sheetId: sheetId, rows: [[item.id, item.parentId ?? "", item.type.rawValue, item.name]])
    }
    
    func delete(item: FilesystemItem) async throws {
        fatalError("Not implemented")
    }
}

extension DefaultFilesystemNetworkDataSource {
    enum DefaultFilesystemNetworkDataSourceError: Error {
        case invalidRowFormat
        case invalidRowType
    }
}

//
//  DefaultFilesystemRepository.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

struct DefaultFilesystemRepository: FilesystemRepository {
    let networkDataSource: FilesystemNetworkDataSource
    
    func items(forParent parentId: String?) async throws -> [FilesystemItem] {
        try await networkDataSource.items(forParent: parentId)
    }
    
    func insert(item: FilesystemItem) async throws {
        try await networkDataSource.insert(item: item)
    }
    
    func delete(item: FilesystemItem) async throws {
        // todo
    }
}

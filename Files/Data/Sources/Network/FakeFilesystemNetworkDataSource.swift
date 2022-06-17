//
//  FakeFilesystemNetworkDataSource.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

#if DEBUG
struct FakeFilesystemNetworkDataSource: FilesystemNetworkDataSource {
    func items(forParent parentId: String?) async throws -> [FilesystemItem] {
        return (0...100).map { index in
            FilesystemItem(
                id: UUID().uuidString,
                parentId: parentId,
                type: index % 3 == 0 ? .directory : .file,
                name: "Item \(index)"
            )
        }
    }
    
    func insert(item: FilesystemItem) async throws {
        fatalError("Not implemented")
    }
    
    func delete(item: FilesystemItem) async throws {
        fatalError("Not implemented")
    }
}
#endif

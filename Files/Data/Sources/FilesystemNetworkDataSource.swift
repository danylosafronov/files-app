//
//  FilesystemNetworkDataSource.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

protocol FilesystemNetworkDataSource {
    func items(forParent parentId: String?) async throws -> [FilesystemItem]
    func insert(item: FilesystemItem) async throws
    func delete(item: FilesystemItem) async throws
}

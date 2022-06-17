//
//  DefaultGetFilesystemItemsUseCase.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

struct DefaultGetFilesystemItemsUseCase: GetFilesystemItemsUseCase {
    let repository: FilesystemRepository
    
    func invoke(parentId: String?) async throws -> [FilesystemItem] {
        try await repository.items(forParent: parentId)
    }
}

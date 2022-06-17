//
//  DefaultDeleteFilesystemItemUseCase.swift
//  Files
//
//  Created by Danylo Safronov on 16.06.2022.
//

import Foundation

struct DefaultDeleteFilesystemItemUseCase: DeleteFilesystemItemUseCase {
    let repository: FilesystemRepository
    
    func invoke(item: FilesystemItem) async throws {
        try await repository.delete(item: item)
    }
}

//
//  GetFilesystemItemsUseCase.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

protocol GetFilesystemItemsUseCase {
    func invoke(parentId: String?) async throws -> [FilesystemItem]
}

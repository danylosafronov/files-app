//
//  CreateFilesystemItemUseCase.swift
//  Files
//
//  Created by Danylo Safronov on 16.06.2022.
//

import Foundation

protocol SaveFilesystemItemUseCase {
    func invoke(item: FilesystemItem) async throws
}

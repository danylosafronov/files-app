//
//  DeleteFilesystemItemUseCase.swift
//  Files
//
//  Created by Danylo Safronov on 16.06.2022.
//

import Foundation

protocol DeleteFilesystemItemUseCase {
    func invoke(item: FilesystemItem) async throws
}

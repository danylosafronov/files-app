//
//  FilesystemItem.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import Foundation

struct FilesystemItem: Identifiable {
    let id: String
    let index: Int
    let parentId: String?
    let type: FilesystemItemType
    let name: String
}

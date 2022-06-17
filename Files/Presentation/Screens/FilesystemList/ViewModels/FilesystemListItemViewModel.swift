//
//  FilesystemListItemViewModel.swift
//  Files
//
//  Created by Danylo Safronov on 13.06.2022.
//

import Foundation

final class FilesystemListItemViewModel: Identifiable {
    private (set) var item: FilesystemItem
    
    var id: String {
        item.id
    }
    
    init(item: FilesystemItem) {
        self.item = item
    }
}

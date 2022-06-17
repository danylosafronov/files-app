//
//  FilesystemListViewDataSource.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

protocol FilesystemListViewDataSource: AnyObject {
    func numberOfItems(inSection section: Int) -> Int
    func item(at index: IndexPath) -> FilesystemListItemViewModel?
}

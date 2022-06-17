//
//  FilesystemListViewDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 13.06.2022.
//

import Foundation

protocol FilesystemListViewDelegate: AnyObject {
    func didSelectItem(at index: IndexPath)
}

extension FilesystemListViewDelegate {
    func didSelectItem(at index: IndexPath) { }
}

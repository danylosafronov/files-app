//
//  FilesystemListViewControllerDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

protocol FilesystemListViewControllerDelegate: AnyObject {
    func didSelectItem(_ item: FilesystemItem)
    func didInitializeSignOut()
}

extension FilesystemListViewControllerDelegate {
    func didSelectItem(_ item: FilesystemItem) { }
    func didInitializeSignOut() { }
}

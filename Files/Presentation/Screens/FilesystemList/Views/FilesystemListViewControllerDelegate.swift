//
//  FilesystemListViewControllerDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation

@MainActor protocol FilesystemListViewControllerDelegate: AnyObject {
    func didSelectItem(_ item: FilesystemItem)
    func didTapSignOut()
}

extension FilesystemListViewControllerDelegate {
    func didSelectItem(_ item: FilesystemItem) { }
    func didTapSignOut() { }
}

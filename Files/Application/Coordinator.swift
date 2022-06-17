//
//  Coordinator.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation
import UIKit

final class Coordinator: FilesystemListViewControllerDelegate {
    private let rootController: UINavigationController
    private let rootContainer: Container
    
    init(rootController: UINavigationController, rootContainer: Container) {
        self.rootController = rootController
        self.rootContainer = rootContainer
    }
    
    func start() {
        coordinateToFilesystemListViewController(parent: nil)
    }
    
    func coordinateToFilesystemListViewController(parent: FilesystemItem? = nil) {
        let controller = FilesystemListViewController(viewModel: rootContainer.makeFilesystemListViewModel(forParent: parent))
        controller.delegate = self
        
        rootController.pushViewController(controller, animated: true)
    }
    
    // MARK: - FilesystemListViewControllerDelegate
    
    func didSelectItem(_ item: FilesystemItem) {
        switch item.type {
        case .directory: coordinateToFilesystemListViewController(parent: item)
        case .file: break
        }
    }
}

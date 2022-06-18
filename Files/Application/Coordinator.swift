//
//  Coordinator.swift
//  Files
//
//  Created by Danylo Safronov on 14.06.2022.
//

import Foundation
import UIKit

final class Coordinator: AuthorizationViewControllerDelegate, FilesystemListViewControllerDelegate {
    let rootController: UINavigationController
    private let rootContainer: Container
    
    weak var delegate: CoordinatorDelegate?
    
    init(rootController: UINavigationController, rootContainer: Container) {
        self.rootController = rootController
        self.rootContainer = rootContainer
    }
    
    func start() {
        coordinateToHome()
    }
    
    func coordinateToHome() {
        let controller = makeFilesystemListViewController()
        if let controller = rootController.visibleViewController, controller.isModalInPresentation {
            controller.dismiss(animated: true)
        }
        
        rootController.setViewControllers([controller], animated: false)
    }
    
    func coordinateToAuthorizationController() {
        let controller = makeAuthorizationController()
        rootController.present(controller, animated: true)
    }
    
    func coordinateToFilesystemListViewController(parent: FilesystemItem? = nil) {
        let controller = makeFilesystemListViewController(parent: parent)
        rootController.pushViewController(controller, animated: true)
    }
    
    private func makeAuthorizationController() -> UIViewController {
        let controller = AuthorizationViewController()
        controller.isModalInPresentation = true
        controller.modalPresentationStyle = .formSheet
        controller.delegate = self
        
        return controller
    }
    
    private func makeFilesystemListViewController(parent: FilesystemItem? = nil) -> UIViewController {
        let controller = FilesystemListViewController(viewModel: rootContainer.makeFilesystemListViewModel(forParent: parent))
        controller.delegate = self
        
        return controller
    }
    
    // MARK: - AuthorizationViewControllerDelegate
    
    func didInitializeSignInWithGoogle() {
        delegate?.didInitializeSignInWithGoogle()
    }
    
    // MARK: - FilesystemListViewControllerDelegate
    
    func didSelectItem(_ item: FilesystemItem) {
        switch item.type {
        case .directory: coordinateToFilesystemListViewController(parent: item)
        case .file: break
        }
    }
    
    func didInitializeSignOut() {
        delegate?.didInitializeSignOut()
    }
}

//
//  SceneDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        AppAppearance.configureAppearance()
        
        let rootController = UINavigationController()
        let container = Container()
        let coordinator = Coordinator(rootController: rootController, rootContainer: container)
        
        let window = UIWindow(windowScene: scene)
        
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        coordinator.start()
        
        self.window = window
        self.coordinator = coordinator
        self.container = container
    }
}

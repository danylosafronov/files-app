//
//  SceneDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 11.06.2022.
//

import UIKit
import GoogleSignIn

final class SceneDelegate: UIResponder, UIWindowSceneDelegate, CoordinatorDelegate {

    var window: UIWindow?
    var container: Container?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        AppAppearance.configureAppearance()
        
        let rootController = UINavigationController()
        rootController.view.backgroundColor = .systemBackground
        
        let container = Container()
        let coordinator = Coordinator(rootController: rootController, rootContainer: container)
        coordinator.delegate = self
        
        let window = UIWindow(windowScene: scene)
        
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        
        self.window = window
        self.coordinator = coordinator
        self.container = container
        
        restoreAuthrorizationState()
    }
    
    // MARK: - Logic
    
    private func restoreAuthrorizationState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self = self else {
                return
            }
            
            var authorizationState: AuthroizationState? = nil
            if error == nil, let user = user {
                authorizationState = .init(token: user.authentication.accessToken)
            }
            
            self.didRestoredAuthorizationState(authorizationState)
        }
    }
    
    private func resolveCoordination(byAuthorizationState state: AuthroizationState?) {
        guard let state = state else {
            coordinator?.coordinateToAuthorizationController()
            return
        }

        container?.authroizationState = state
        coordinator?.coordinateToHome()
    }
    
    // MARK: - Events
    
    private func didRestoredAuthorizationState(_ state: AuthroizationState?) {
        resolveCoordination(byAuthorizationState: state)
    }
    
    // MARK: - CoordinatorDelegate
    
    func didInitializeSignInWithGoogle() {
        guard let coordinator = coordinator else { return }
        
        let apiClientId = Configuration.requiredString(byKey: "API_CLIENT_ID")
        let signInConfig = GIDConfiguration(clientID: apiClientId)
        let scopes = ["https://www.googleapis.com/auth/spreadsheets"]
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: coordinator.rootController, hint: nil, additionalScopes: scopes) { [weak self] user, error in
            guard error == nil,
                  let user = user,
                  let self = self
            else { return }

            let token = user.authentication.accessToken
            let state = AuthroizationState(token: token)
            
            self.container?.authroizationState = state
            self.coordinator?.coordinateToHome()
          }
    }
    
    func didInitializeSignOut() {
        GIDSignIn.sharedInstance.signOut()
        coordinator?.coordinateToAuthorizationController()
    }
}

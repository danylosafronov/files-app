//
//  AuthorizationViewController.swift
//  Files
//
//  Created by Danylo Safronov on 17.06.2022.
//

import GoogleSignIn
import UIKit

final class AuthorizationViewController: UIViewController, AuthorizationViewDelegate {
    private lazy var defaultView = AuthorizationView()
    
    weak var delegate: AuthorizationViewControllerDelegate?
    
    // MARK: - Overrides
    
    override func loadView() {
        super.loadView()
        
        defaultView.delegate = self
        view = defaultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - AuthorizationViewDelegate
    
    func didTapSignInWithGoogle() {
        delegate?.didTapSignInWithGoogle()
    }
}

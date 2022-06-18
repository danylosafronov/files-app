//
//  AuthorizationViewControllerDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 17.06.2022.
//

import Foundation

protocol AuthorizationViewControllerDelegate: AnyObject {
    func didTapSignInWithGoogle()
}

extension AuthorizationViewControllerDelegate {
    func didTapSignInWithGoogle() { }
}

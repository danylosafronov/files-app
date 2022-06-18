//
//  AuthorizationViewDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 17.06.2022.
//

import Foundation

protocol AuthorizationViewDelegate: AnyObject {
    func didTapSignInWithGoogle()
}

extension AuthorizationViewDelegate {
    func didTapSignInWithGoogle() { }
}

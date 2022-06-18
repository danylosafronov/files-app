//
//  AuthorizationViewDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 17.06.2022.
//

import Foundation

protocol AuthorizationViewDelegate: AnyObject {
    func didTapSignInWithGoogleButton()
}

extension AuthorizationViewDelegate {
    func didTapSignInWithGoogleButton() { }
}

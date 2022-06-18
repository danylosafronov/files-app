//
//  CoordinatorDelegate.swift
//  Files
//
//  Created by Danylo Safronov on 18.06.2022.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
    func didInitializeSignInWithGoogle()
    func didInitializeSignOut()
}

extension CoordinatorDelegate {
    func didInitializeSignInWithGoogle() { }
    func didInitializeSignOut() { }
}

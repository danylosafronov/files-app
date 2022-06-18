//
//  AuthorizationState.swift
//  Files
//
//  Created by Danylo Safronov on 17.06.2022.
//

import Foundation

struct AuthroizationState {
    var token: String? = nil
}

extension AuthroizationState {
    var isAuthorized: Bool {
        token != nil
    }
}

//
//  GSheetError.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation

enum GSheetErrors: Error {
    case malformedUrl
    case invalidUrl
    case badServerResponse
}

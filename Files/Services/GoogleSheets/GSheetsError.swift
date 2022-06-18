//
//  GSheetError.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation

enum GSpreadsheetError: Error {
    case malformedUrl
    case invalidUrl
    case badServerResponse
    case unauthorized
}

//
//  GSheetResponseModel.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation

struct GSheetResponseModel: Codable {
    let range: String
    let dimension: String
    let rows: [[String]]
    
    enum CodingKeys: String, CodingKey {
        case range
        case dimension = "majorDimension"
        case rows = "values"
    }
}

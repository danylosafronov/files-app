//
//  GoogleSheetsServiceConfiguration.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation

struct GSheetServiceConfiguration {
    let authorizationToken: String?
    let baseUrl: String = "https://sheets.googleapis.com/v4/spreadsheets"
}

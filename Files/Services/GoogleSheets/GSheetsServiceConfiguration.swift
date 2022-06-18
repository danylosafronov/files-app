//
//  GoogleSheetsServiceConfiguration.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation

struct GSpreadsheetServiceConfiguration {
    let authorizationToken: String?
    let baseUrl: String = "https://sheets.googleapis.com"
    let apiVersion: String = "v4"
    let apiService: String = "spreadsheets"
}

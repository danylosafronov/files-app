//
//  GoogleSheets.swift
//  Files
//
//  Created by Danylo Safronov on 15.06.2022.
//

import Foundation

struct GSheetsService {
    let configuration: GSheetServiceConfiguration
    
    func fetch(sheetId: String) async throws -> GSheetResponseModel {
        guard let authorizationToken = configuration.authorizationToken else {
            throw GSheetErrors.unauthorized
        }
        
        let url = try makeSheetValuesUrl(forSheet: sheetId)
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        
        let (responseData, _) = try await execute(with: request)
        let data = try JSONDecoder().decode(GSheetResponseModel.self, from: responseData)
        
        return data
    }
    
    private func execute(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response  else {
                    let error = error ?? GSheetErrors.badServerResponse
                    return continuation.resume(throwing: error)
                }
                
                return continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
    
    private func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }
    
    private func makeSheetValuesUrl(forSheet sheetId: String) throws -> URL {
        let urlComponents = try makeSheetUrlComponents(string: "\(configuration.baseUrl)/\(sheetId)/values/1:1000")
        guard let url = urlComponents.url else {
            throw GSheetErrors.invalidUrl
        }
        
        return url
    }
    
    private func makeSheetUrlComponents(string: String, parameters: [String: String] = [:]) throws -> URLComponents {
        guard var urlComponents = URLComponents(string: string) else {
            throw GSheetErrors.malformedUrl
        }
        
        urlComponents.queryItems = parameters.map { .init(name: $0.key, value: $0.value) }
        return urlComponents
    }
}

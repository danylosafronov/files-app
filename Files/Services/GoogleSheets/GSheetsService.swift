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
        
        let url = try makeSheetUrl("values", forSheet: sheetId, range: ("1", "1000"))
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        
        let (responseData, _) = try await execute(with: request)
        let data = try JSONDecoder().decode(GSheetResponseModel.self, from: responseData)
        
        return data
    }
    
    func insert(sheetId: String, rows: [[String]]) async throws {
        guard let authorizationToken = configuration.authorizationToken else {
            throw GSheetErrors.unauthorized
        }
        
        let url = try makeSheetUrl("values", forSheet: sheetId, range: ("1", "1000"), action: "append", parameters: ["valueInputOption": "RAW"])
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if !rows.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["values": rows])
        }
        
        let (_, _) = try await execute(with: request)
    }
    
    private func execute(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response  else {
                    let error = error ?? GSheetErrors.badServerResponse
                    return continuation.resume(throwing: error)
                }
                
                if let response = response as? HTTPURLResponse, !(200 ..< 300).contains(response.statusCode) {
                    let error = GSheetErrors.badServerResponse
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
    
    private func makeSheetUrl(_ resource: String, forSheet sheetId: String, range: (String, String), action: String? = nil, parameters: [String: String]? = nil) throws -> URL {
        var range = "\(range.0):\(range.1)"
        if let action = action {
            range += ":\(action)"
        }
        
        let path: [String] = [configuration.apiVersion, configuration.apiService, sheetId, resource, range]
        let urlComponents = try makeSheetUrlComponents(string: configuration.baseUrl, path: path, parameters: parameters)
        
        guard let url = urlComponents.url else {
            throw GSheetErrors.invalidUrl
        }
        
        return url
    }
    
    private func makeSheetUrlComponents(string: String, path: [String], parameters: ([String: String])? = nil) throws -> URLComponents {
        guard var urlComponents = URLComponents(string: string) else {
            throw GSheetErrors.malformedUrl
        }
        
        urlComponents.path = "/\(path.joined(separator: "/"))"
        urlComponents.queryItems = parameters?.map { .init(name: $0.key, value: $0.value) }

        return urlComponents
    }
}

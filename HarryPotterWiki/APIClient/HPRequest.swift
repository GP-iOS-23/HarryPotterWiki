//
//  HPRequest.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

/// Creating requests 
final class HPRequest {
    private struct Constants {
        static let baseURL = "https://api.potterdb.com/v1"
    }
    
    let endpoint: HPEndpoint
    
    private let pathComponents: [String]
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty{
            pathComponents.forEach{
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap{
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    // MARK: - init
    
    public init(
        endpoint: HPEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init? (url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let hpEndpoint = HPEndpoint(rawValue: endpointString) {
                    self.init(endpoint: hpEndpoint, pathComponents: components)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemString = components[1]
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                
                if let hpEndpoint = HPEndpoint(rawValue: endpointString) {
                    self.init(endpoint: hpEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension HPRequest {
    static let listBooksRequest = HPRequest(endpoint: .books)
    static let listCharactersRequest = HPRequest(endpoint: .characters, queryParameters: [
        URLQueryItem(name: "filter[name_not_start]", value: "Unidentified"),
        URLQueryItem(name: "filter[name_not_start]", value: "Undentified"),
        URLQueryItem(name: "filter[patronus_not_null]", value: "true"),
    ])
    static let listMoviesRequest = HPRequest(endpoint: .movies)
    static let listSpellsRequest = HPRequest(endpoint: .spells, queryParameters: [
        URLQueryItem(name: "page[size]", value: "25")
    ])
    static let listPoitionsRequest = HPRequest(endpoint: .potions, queryParameters: [
        URLQueryItem(name: "page[size]", value: "25")
    ])
}

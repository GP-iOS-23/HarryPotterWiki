//
//  HPService.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

protocol HPNetworkServiceProtocol {
    func execute<T:Codable>(
        _ request: HPRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class HPService: HPNetworkServiceProtocol {
    static let shared = HPService()
    
    private let cacheManager = HPAPICacheManager()
    
    private init() {}
    
    enum HPServiceErrors: Error {
        case failedToCreateRequest
        case failedToFetchData
    }
    
    public func execute<T: Codable>(
        _ request: HPRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            do {
                let result = try decoder.decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                print("Cache decode failed")
                completion(.failure(error))
            }
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(HPServiceErrors.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? HPServiceErrors.failedToFetchData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let result = try decoder.decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                print("Cache set failed, error: \(String(describing: error))")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func request(from request: HPRequest) -> URLRequest? {
        guard let url = request.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}


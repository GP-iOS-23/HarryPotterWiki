//
//  HPSearchService.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 23.01.2025.
//

import Foundation

protocol HPSearchServiceProtocol {
    func searchCharacters(
        query: String,
        completion: @escaping (Result<[HPCharacter], Error>) -> Void
    )
}

final class HPSearchService: HPSearchServiceProtocol {
    private let networkService: HPNetworkServiceProtocol
    
    init(networkService: HPNetworkServiceProtocol = HPService.shared) {
        self.networkService = networkService
    }
    
    func searchCharacters(
        query: String,
        completion: @escaping (Result<[HPCharacter], Error>) -> Void
    ) {
        let searchQueryItem = [URLQueryItem(name: "filter[name_cont_any]", value: query)]
        
        let request = HPRequest(
            endpoint: .characters,
            queryParameters: searchQueryItem
        )
        
        networkService.execute(request, expecting: HPGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let responseModel):
                completion(.success(responseModel.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

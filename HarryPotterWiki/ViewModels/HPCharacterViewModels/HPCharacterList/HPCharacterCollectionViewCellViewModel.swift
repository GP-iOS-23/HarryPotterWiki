//
//  HPCharacterCollectionViewCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 21.12.2024.
//

import Foundation
import UIKit

final class HPCharacterCollectionViewCellViewModel: Hashable, Equatable {
    public let characterName: String
    private let characterImageURL: URL?
    private let houseName: String
    private var loadTaskUUID: UUID?
    
//    init(characterName: String, characterImageURL: URL?, houseName: String) {
//        self.characterName = characterName
//        self.characterImageURL = characterImageURL
//        self.houseName = houseName
//    }
    
    init(character: HPCharacter) {
        self.characterName = character.attributes.name
        self.characterImageURL = URL(string: character.attributes.image ?? "")
        self.houseName = character.attributes.house ?? ""
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        if let uuid = loadTaskUUID {
            HPImageLoader.shared.cancelLoad(uuid)
        }
        
        loadTaskUUID = HPImageLoader.shared.fetchImage(with: url, completion: completion)
    }
    
    func cancelLoad() {
        if let uuid = loadTaskUUID {
            HPImageLoader.shared.cancelLoad(uuid)
        }
    }
    
    static func == (lhs: HPCharacterCollectionViewCellViewModel, rhs: HPCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterImageURL)
    }
}

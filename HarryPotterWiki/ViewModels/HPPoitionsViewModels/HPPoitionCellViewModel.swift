//
//  HPPoitionCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 09.01.2025.
//

import Foundation

final class HPPoitionCellViewModel: Hashable, Equatable {
    private let poition: HPPoition
    
    public var name: String {
        poition.attributes.name
    }
    
    public var difficulty: NSAttributedString {
        "Difficulty: \(poition.attributes.difficulty ?? "None/Unknown")".createAttributedString(boldRange: "Difficulty:")
    }
    
    public var effects: NSAttributedString {
        "Effect: \(poition.attributes.effect ?? "None/Unknown")".createAttributedString(boldRange: "Effect:")
    }
    
    public var sideEffects: NSAttributedString {
        "Side effects: \(poition.attributes.sideEffects ?? "None/Unknown")".createAttributedString(boldRange: "Side effects:")
    }
    
    public var ingridients: NSAttributedString {
        "Ingridients: \(poition.attributes.ingridients ?? "None/Unknown")".createAttributedString(boldRange: "Ingridients:")
    }
    
    init(poition: HPPoition) {
        self.poition = poition
    }
    
    static func == (lhs: HPPoitionCellViewModel, rhs: HPPoitionCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(difficulty)
        hasher.combine(effects)
        hasher.combine(sideEffects)
        hasher.combine(ingridients)
    }
}

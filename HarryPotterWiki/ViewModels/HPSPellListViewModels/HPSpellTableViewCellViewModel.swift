//
//  HPSpellTableViewCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation

final class HPSpellTableViewCellViewModel: Hashable, Equatable {
    private let spell: HPSpell
    
    public var name: String {
        spell.attributes.name
    }
    public var category: NSAttributedString {
        return "Category: \(spell.attributes.category ?? "Unknown")".createAttributedString(boldRange: "Category:")
    }
    public var effect: NSAttributedString {
        return "Effect: \(spell.attributes.effect ?? "Unknown")".createAttributedString(boldRange: "Effect:")
    }
    public var light: NSAttributedString {
        return "Light: \(spell.attributes.light ?? "Unknown")".createAttributedString(boldRange: "Light:")
    }
    public var incantation: NSAttributedString {
        return "Incantation: \(spell.attributes.incantation ?? "Unknown")".createAttributedString(boldRange: "Incantation:")
    }
    
    init(spell: HPSpell) {
        self.spell = spell
    }
    
    static func ==(lhs: HPSpellTableViewCellViewModel, rhs: HPSpellTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(category)
        hasher.combine(effect)
        hasher.combine(light)
        hasher.combine(incantation)
    }
}

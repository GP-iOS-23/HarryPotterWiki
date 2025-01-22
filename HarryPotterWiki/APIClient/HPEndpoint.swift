//
//  HPEndpoint.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

@frozen public enum HPEndpoint: String, CaseIterable, Hashable {
    case books
    case characters
    case movies
    case spells
    case potions
}

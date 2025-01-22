//
//  HPHouseColor.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 20.12.2024.
//

import Foundation
import CoreGraphics

enum HPHouseColor {
    case gryffindor
    case hufflepuff
    case ravenclaw
    case slytherin
    
    var color: CGColor {
        switch self {
        case .gryffindor:
            return CGColor(red: 0.76, green: 0.0, blue: 0.0, alpha: 1.0)
        case .hufflepuff:
            return CGColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        case .ravenclaw:
            return CGColor(red: 0.0, green: 0.28, blue: 0.67, alpha: 1.0)
        case .slytherin:
            return CGColor(red: 0.0, green: 0.39, blue: 0.2, alpha: 1.0)
        }
    }
}

//
//  HPRootViewCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPRootViewCellViewModel {
    public let sectionName: String
    public let sectionImage: UIImage?
    public let type: HPRootViewSection
    
    init(type: HPRootViewSection) {
        self.sectionName = type.rawValue
        self.sectionImage = UIImage(named: type.rawValue)
        self.type = type
    }
}

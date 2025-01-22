//
//  HPSettingsViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation
import UIKit

final class HPSettingsViewModel: NSObject {
    
    public func themeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            HPThemeManager.shared.currentTheme = .light
        case 1:
            HPThemeManager.shared.currentTheme = .dark
        case 2:
            HPThemeManager.shared.currentTheme = .system
        default:
            break
        }
    }
}

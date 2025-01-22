//
//  HPThemeManager.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation
import UIKit

final class HPThemeManager {
    static let shared = HPThemeManager()
    
    enum AppTheme: String, CaseIterable {
        case light
        case dark
        case system
    }
    
    private let themeKey = "Selected theme"
    
    var currentTheme: AppTheme {
        get {
            if let savedTheme = UserDefaults.standard.string(forKey: themeKey),
               let theme = AppTheme(rawValue: savedTheme) {
                return theme
            }
            return .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            applyTheme(theme: newValue)
        }
    }
    
    func applyTheme(theme: AppTheme) {
        let style: UIUserInterfaceStyle
        
        switch theme {
        case .system:
            style = .unspecified
        case .light:
            style = .light
        case .dark:
            style = .dark
        }
        
        
        guard let window = UIApplication.shared.windows.first else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = style
        }
    }
}

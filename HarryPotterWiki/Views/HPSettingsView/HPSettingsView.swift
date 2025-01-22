//
//  HPSettingsView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation
import UIKit

final class HPSettingsView: UIView {
    private let viewModel: HPSettingsViewModel
    
    private let themeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Light", "Dark", "System"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © Potter DB 2025"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let themeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: HPSettingsViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubviews(copyrightLabel, themeStackView)
        themeStackView.addArrangedSubviews(themeLabel, themeSegmentedControl)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            themeStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            themeStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            themeStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
 
            copyrightLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            copyrightLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setupSegmentedControl() {
        themeSegmentedControl.selectedSegmentIndex = {
            switch HPThemeManager.shared.currentTheme {
            case .light: return 0
            case .dark: return 1
            case .system: return 2
            }
        }()
        themeSegmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
    }
    
    @objc private func themeChanged(_ sender: UISegmentedControl) {
        viewModel.themeChanged(sender)
    }
}

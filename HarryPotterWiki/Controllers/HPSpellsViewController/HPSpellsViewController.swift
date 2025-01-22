//
//  SpellsViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPSpellsViewController: UIViewController {
    private let spellListView = HPSpellListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = "Spells"
        view.backgroundColor = .systemBackground
        view.addSubview(spellListView)
        
        NSLayoutConstraint.activate([
            spellListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            spellListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            spellListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            spellListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

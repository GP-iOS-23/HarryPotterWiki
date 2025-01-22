//
//  RootViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPRootViewController: UIViewController, HPRootViewDelegate {
    
    let mainView = HPRootView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSettingsButton()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(mainView)
        mainView.delegate = self
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    private func addSettingsButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let settingsVC = HPSettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func hpRootView(_ hpRootView: HPRootView, didSelectSection section: HPRootViewSection) {
        let sectionVC: UIViewController = {
            switch section {
            case .books:
                return HPBooksViewController()
            case .characters:
                return HPCharactersViewController()
            case .movies:
                return HPMoviesViewController()
            case .spells:
                return HPSpellsViewController()
            case .poitions:
                return HPPoitionsViewController()
            }
        }()
        navigationController?.pushViewController(sectionVC, animated: true)
    }
}


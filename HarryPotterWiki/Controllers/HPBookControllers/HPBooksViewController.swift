//
//  BooksViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPBooksViewController: UIViewController, HPBooksListViewDelegate {
    let primaryView = HPBooksListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Books"
        view.backgroundColor = .systemBackground
        primaryView.delegate = self
        setupView()
    }
    
    private func setupView() {
        view.addSubview(primaryView)
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func hpBookListView(_ bookListView: HPBooksListView, didSelectBook book: HPBook) {
        let viewModel = HPBookDetailViewViewModel(book: book)
        navigationController?.pushViewController(HPBookDetailViewController(frame: .zero, viewModel: viewModel), animated: true)
    }
}

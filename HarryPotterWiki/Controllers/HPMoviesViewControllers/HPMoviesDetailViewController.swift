//
//  HPMoviesDetailViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 06.01.2025.
//

import Foundation
import UIKit

final class HPMoviesDetailViewController: UIViewController {
    
    private let movie: HPMovie
    private let tableView: HPMoviesDetailView
    private let viewModel: HPMoviesDetailViewViewModel
    
    init(movie: HPMovie) {
        self.movie = movie
        self.viewModel = HPMoviesDetailViewViewModel(movie: movie)
        self.tableView = HPMoviesDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = viewModel.title
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

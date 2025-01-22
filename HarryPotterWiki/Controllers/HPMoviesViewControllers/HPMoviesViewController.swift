//
//  MoviesViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPMoviesViewController: UIViewController, HPMoviesListViewDelegate {
    private let movieListView = HPMoviesListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Movies"
        movieListView.delegate = self
        view.addSubview(movieListView)

        NSLayoutConstraint.activate([
            movieListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            movieListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            movieListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func hpMoviesListView(_ movieListView: HPMoviesListView, didSelect movie: HPMovie) {
        let movieDetailViewController = HPMoviesDetailViewController(movie: movie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

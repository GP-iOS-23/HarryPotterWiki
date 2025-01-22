//
//  HPMovieListViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 05.01.2025.
//

import Foundation
import UIKit

protocol HPMoviesListViewViewModelDelegate: AnyObject {
    func didFetchMovies()
    func didSelectMovie(_ movie: HPMovie)
}

final class HPMoviesListViewViewModel: NSObject {
    public weak var delegate: HPMoviesListViewViewModelDelegate?
    
    private var movies = [HPMovie]() {
        didSet {
            for movie in movies {
                let viewModel = HPMoviesListViewCellViewModel(movie: movie)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels = [HPMoviesListViewCellViewModel]()
    
    public func fetchMovies() {
        HPService.shared.execute(.listMoviesRequest, expecting: HPGetAllMoviesResponse.self) { [weak self] result in
            switch result {
            case .success(let result):
                self?.movies = result.data
                DispatchQueue.main.async {
                    self?.delegate?.didFetchMovies()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension HPMoviesListViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HPMoviesListViewCellView.identifier,
            for: indexPath) as? HPMoviesListViewCellView
        else {
            fatalError()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        delegate?.didSelectMovie(movie)
    }
}

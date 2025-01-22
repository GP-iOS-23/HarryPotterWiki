//
//  HPMoviesDetailViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 06.01.2025.
//

import Foundation
import UIKit

final class HPMoviesDetailViewViewModel: NSObject {
    private let movie: HPMovie
    
    public var title: String {
        movie.attributes.title
    }
    
    private var additionalInfo: [NSAttributedString] {
        movie.attributes.additionalInfo.map {
            let range = $0.prefix(while: { $0 != ":"})
            return $0.createAttributedString(boldRange: String(range))
        }
    }
    
    private var isTrailerSectionExpanded = false
    
    public var trailerVideoID: String {
        movie.attributes.trailer.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
    }
    
    init(movie: HPMovie) {
        self.movie = movie
    }
    
    private func toggleTrailerSection() {
        isTrailerSectionExpanded.toggle()
    }
    
    private func isTrailerSectionExpandedState() -> Bool {
        isTrailerSectionExpanded
    }
    
    public func fetchPreviewImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let previewURL = URL(string: "https://img.youtube.com/vi/\(trailerVideoID)/hqdefault.jpg") else {
            print("Failed to create trailer preview image URL")
            return
        }
        
        HPImageLoader.shared.fetchImage(with: previewURL, completion: completion)
    }
}

extension HPMoviesDetailViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return additionalInfo.count
        case 2:
            return isTrailerSectionExpanded ? 1 : 0
        default :
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: HPMoviesMainInfoTableViewCell.identifier, for: indexPath) as? HPMoviesMainInfoTableViewCell
            else {
                fatalError()
            }
            let viewModel = HPMoviesMainInfoTableViewCellViewModel(movie: movie)
            cell.configure(with: viewModel)
            return cell
            
        case 1:
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: HPMoviesDetailTableViewCell.identifier, for: indexPath) as? HPMoviesDetailTableViewCell
            else {
                fatalError()
            }
            let text = additionalInfo[indexPath.row]
            cell.configure(text)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HPMoviesDetailTrailerViewCell.identifier, for: indexPath) as? HPMoviesDetailTrailerViewCell
            else {
                fatalError()
            }
            cell.configure(with: self)
            return cell
        default:
            fatalError("Failed to create cell")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 2,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HPMoviesDetailTrailerSectionHeaderView.identifier) as? HPMoviesDetailTrailerSectionHeaderView
        else {
            return nil
        }
        header.configureButton(isTrailerSectionExpanded)
        header.didTapExpand = { [weak self] in
            self?.toggleTrailerSection()
            
            DispatchQueue.main.async {
                tableView.reloadSections(IndexSet(integer: section), with: .fade)
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 2 ? 30 : 0
    }
}

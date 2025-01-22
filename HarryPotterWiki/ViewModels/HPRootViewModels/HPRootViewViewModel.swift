//
//  HPRootViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

protocol HPRootViewViewModelDelegate: AnyObject {
    func didSelectSection(with type: HPRootViewSection)
}

final class HPRootViewViewModel: NSObject {
    public weak var delegate: HPRootViewViewModelDelegate?
    
    private let sections = [
        HPRootViewCellViewModel(type: .books),
        HPRootViewCellViewModel(type: .characters),
        HPRootViewCellViewModel(type: .movies),
        HPRootViewCellViewModel(type: .poitions),
        HPRootViewCellViewModel(type: .spells),
    ]
}

extension HPRootViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HPRootViewCell.cellIdentifier,
            for: indexPath) as? HPRootViewCell
        else { fatalError("Unsupported cell") }
        cell.configure(with: sections[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = CGFloat((bounds.width-30) / 2)
        
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.row].type
        delegate?.didSelectSection(with: sectionType)
    }
}

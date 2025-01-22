//
//  HPCharacterDetailViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 23.12.2024.
//

import Foundation
import UIKit

final class HPCharacterDetailViewViewModel: NSObject {
    private let character: HPCharacter
    
    init(character: HPCharacter) {
        self.character = character
    }
    
    public var title: String {
        let title = character.attributes.slug.replacingOccurrences(of: "-", with: " ").capitalized
        return title
    }
    
    private var additionalInfo: [String] {
        character.attributes.additionalInfo
    }
    
    public var houseColor: UIColor {
        switch character.attributes.house {
        case "Gryffindor":
            return UIColor(cgColor: HPHouseColor.gryffindor.color)
        case "Slytherin":
            return UIColor(cgColor: HPHouseColor.slytherin.color)
        case "Hufflepuff":
            return UIColor(cgColor: HPHouseColor.hufflepuff.color)
        case "Ravenclaw":
            return UIColor(cgColor: HPHouseColor.ravenclaw.color)
        default:
            return .secondarySystemBackground
        }
    }
}

extension HPCharacterDetailViewViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : additionalInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HPCharacterMainInfoCellView.identifier, for: indexPath) as? HPCharacterMainInfoCellView
            else {
                fatalError("Failed to dequeue Main info cell")
            }
            let viewModel = HPCharacterCellViewModel(character: character)
            cell.configure(with: viewModel)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HPCharacterDetailViewCell.identifier, for: indexPath) as? HPCharacterDetailViewCell
            else {
                fatalError("Failed to dequeue Additional info cell")
            }
            let text = additionalInfo[indexPath.row]
            let range = text.prefix(while: { $0 != ":" })
            let attributedText = text.createAttributedString(boldRange: String(range))
            cell.configure(attributedText)
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

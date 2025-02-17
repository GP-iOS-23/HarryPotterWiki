//
//  HPCharacterCollectionViewCellView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 21.12.2024.
//

import Foundation
import UIKit

final class HPCharacterCollectionViewCellView: UICollectionViewCell {
    static let identifier = "HPCharacterCollectionViewCellView"
    
    private var shadowLayer: CALayer?
    private var currentViewModel: HPCharacterCollectionViewCellViewModel?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.tintColor = .secondarySystemFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(imageView, nameLabel)
        setupConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported cell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
    }
    
    private func setupLayer() {
        shadowLayer?.removeFromSuperlayer()
        
        let shadowLayer = CALayer()
        shadowLayer.frame = contentView.frame
        shadowLayer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
        shadowLayer.shadowColor = UIColor.label.cgColor
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowOffset = CGSize(width: 2, height: 2)
        shadowLayer.shadowRadius = 4
        shadowLayer.shouldRasterize = true
        shadowLayer.rasterizationScale = UIScreen.main.scale
        
        layer.insertSublayer(shadowLayer, at: 0)
        self.shadowLayer = shadowLayer
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer?.frame = contentView.frame
        shadowLayer?.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        shadowLayer?.shadowColor = UIColor.label.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentViewModel?.cancelLoad()
        currentViewModel = nil
        imageView.image = nil
        nameLabel.text = nil
    }
    
    public func configure(with viewModel: HPCharacterCollectionViewCellViewModel) {
        currentViewModel = viewModel
        
        nameLabel.text = viewModel.characterName
        contentView.backgroundColor = .secondarySystemBackground
        imageView.image = UIImage(named: "placeholder")
        
        viewModel.fetchImage(completion: { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    UIView.transition(
                        with: self.imageView,
                        duration: 0.35,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.imageView.image = image
                        })
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    let image = UIImage(systemName: "person.fill")
                    self.imageView.image = image
                }
                print(String(describing: error))
                break
            }
        })
    }
}

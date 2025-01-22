//
//  HPMoviesDetailTrailerViewCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.01.2025.
//

import Foundation
import UIKit

final class HPMoviesDetailTrailerViewCell: UITableViewCell {
    static let identifier = "HPMoviesDetailTrailerViewCell"
    
    private var videoID = ""
    
    private let trailerPreview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .heavy, scale: .large)
        button.setImage(
            UIImage(systemName: "play.fill", withConfiguration: config),
            for: .normal)
        button.tintColor = .white
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        contentView.addSubviews(trailerPreview, playButton)
        contentView.sendSubviewToBack(trailerPreview)
        
        NSLayoutConstraint.activate([
            trailerPreview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            trailerPreview.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            trailerPreview.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            trailerPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            trailerPreview.heightAnchor.constraint(equalToConstant: 170),
            
            playButton.centerXAnchor.constraint(equalTo: trailerPreview.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: trailerPreview.centerYAnchor),
        ])
    }
    
    private func setupButton() {
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2,
                       animations: { sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85) },
                       completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        })
        
        if let youtuBeAppURL = URL(string: "youtube://\(videoID)"),
           UIApplication.shared.canOpenURL(youtuBeAppURL) {
            UIApplication.shared.open(youtuBeAppURL)
        } else if let webURL = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
            UIApplication.shared.open(webURL)
        }   
    }
    
    public func configure(with viewModel: HPMoviesDetailViewViewModel) {
        videoID = viewModel.trailerVideoID
        
        viewModel.fetchPreviewImage() { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.trailerPreview.image = image
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

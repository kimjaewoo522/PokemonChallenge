//
//  MainViewCell.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/15/25.
//

import UIKit
import SnapKit

class MainViewCell: UICollectionViewCell {
    
    static let id = "MainViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        styleUI()
        setupConstraints()
    }
    
    private func styleUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
        
    func configure(with item: Detail) {
        imageView.image = nil
        loadImage(from: item.sprites.other.officialArtwork.frontDefault, fallbackName: item.name)
    }
    
    private func loadImage(from urlString: String?, fallbackName: String) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}

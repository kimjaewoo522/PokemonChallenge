//
//  MainViewCell.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/15/25.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    static let id = "MainViewCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
        
    func configure(with item: MainViewModel.PokemonItem) {
        imageView.image = nil

        guard let urlString = item.imageURL,
              let url = URL(string: urlString) else {
            print("이미지 URL 없음: \(item.name)")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                print("이미지 로딩 실패: \(item.name)")
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
    
}

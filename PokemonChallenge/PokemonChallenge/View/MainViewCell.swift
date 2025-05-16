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
        
    func configure(with result: Result) {
        imageView.image = nil

        guard let id = result.url.split(separator: "/").last,
              let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png") else {
            print(" 이미지 URL 파싱 실패: \(result.url)")
            return
        }

        print("다운로드 시도: \(imageURL)")

        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  let data = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: data) else {
                print(" 이미지 로딩 실패 for \(result.name)")
                return
            }
            DispatchQueue.main.async {
                print("이미지 렌더링 성공 for \(result.name)")
                self.imageView.image = image
            }
        }
    }
    
}

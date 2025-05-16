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
        imageView.frame = contentView.bounds
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
        
    func configure(with result: Result) {
            imageView.image = nil // 이전 셀 재사용 대비

            guard let id = result.url.split(separator: "/").last,
                  let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png") else {
                return
            }

        // 이미지 로딩 작업을 백그라운드 스레드에서처리
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  // 동기 방식으로 이미지 데이터를 요청
                  let data = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: data) else { return }
            // 이미지 설정은 반드시 메인 스레드에서 실행되어야 하므로 다시 전환
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
        
}

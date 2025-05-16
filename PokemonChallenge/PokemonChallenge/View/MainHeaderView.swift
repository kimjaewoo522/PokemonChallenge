//
//  MainHeaderView.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/16/25.
//

import UIKit
import SnapKit

final class MainHeaderView: UICollectionReusableView {
    
    static let id = "MainHeaderView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pokemonball") // Assets에 있는 이미지 이름
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .mainRed
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-15)
            $0.centerX.equalToSuperview()
        }
    }
}

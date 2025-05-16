//
//  DetailViewController.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/16/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    private let imageView = UIImageView()
    private let infoTextView = UITextView()
    
    // MARK: - Initializer
    init(pokemonID: String) {
        self.viewModel = DetailViewModel()
        super.init(nibName: nil, bundle: nil)
        viewModel.fetchDetail(id: pokemonID)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }

    // MARK: - UI 구성
    private func configureUI() {
        view.backgroundColor = .mainRed
        
        let containerView = UIView()
        containerView.backgroundColor = .darkRed
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        infoTextView.isEditable = false
        infoTextView.isScrollEnabled = false
        infoTextView.backgroundColor = .clear
        infoTextView.textAlignment = .center
        infoTextView.textColor = .white
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(infoTextView)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.greaterThanOrEqualTo(400)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(180)
        }
        
        infoTextView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }

    // MARK: - 바인딩
    private func bind() {
        viewModel.pokemonDetail
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] detail in
                guard let self = self else { return }
                
                let types = detail.types.map { $0.type.name }.joined(separator: ", ")
                let titleText = "No.\(detail.id) \(detail.name.capitalized)\n"
                let infoText = "\n타입: \(types)\n\n키: \(Double(detail.height) / 10)m\n\n몸무게: \(Double(detail.weight) / 10)kg"

                let attributedText = NSMutableAttributedString(
                    string: titleText,
                    attributes: [
                        .font: UIFont.boldSystemFont(ofSize: 35),
                        .foregroundColor: UIColor.white
                    ]
                )

                attributedText.append(NSAttributedString(
                    string: infoText,
                    attributes: [
                        .font: UIFont.boldSystemFont(ofSize: 20),
                        .foregroundColor: UIColor.white
                    ]
                ))

                self.infoTextView.attributedText = attributedText
            })
            .disposed(by: disposeBag)

        viewModel.pokemonImage
            .asDriver()
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}

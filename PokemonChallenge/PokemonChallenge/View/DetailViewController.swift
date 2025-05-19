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

    private let noLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            noLabel,
            nameLabel,
            typeLabel,
            heightLabel,
            weightLabel
        ])
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
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
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(labelStackView)
        
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
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }

    // MARK: - 바인딩
    private func bind() {
        viewModel.translatedId
            .asDriver(onErrorJustReturn: nil)
            .drive(noLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.translatedName
            .asDriver(onErrorJustReturn: nil)
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.koreanTypes
            .asDriver(onErrorJustReturn: [])
            .map { "타입: " + $0.joined(separator: ", ") }
            .drive(typeLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.translatedHeight
            .asDriver(onErrorJustReturn: nil)
            .drive(heightLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.translatedWeight
            .asDriver(onErrorJustReturn: nil)
            .drive(weightLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.pokemonImage
            .asDriver()
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}

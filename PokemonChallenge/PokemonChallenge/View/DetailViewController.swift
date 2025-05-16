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
        viewModel.pokemonDetail
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] detail in
                guard let self = self else { return }

                self.noLabel.text = "No.\(detail.id) \(detail.name.capitalized)"
                self.nameLabel.text = ""
                self.typeLabel.text = "타입: \(detail.koreanTypes.joined(separator: ", "))"
                self.heightLabel.text = "키: \(Double(detail.height) / 10)m"
                self.weightLabel.text = "몸무게: \(Double(detail.weight) / 10)kg"
            })
            .disposed(by: disposeBag)

        viewModel.pokemonImage
            .asDriver()
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}

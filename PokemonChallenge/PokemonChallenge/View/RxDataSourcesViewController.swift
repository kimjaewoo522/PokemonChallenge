//
//  RxDataSourcesViewController.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/16/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class RxDataSourcesViewController: UIViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.id)
    }

    private func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Result>>(configureCell: { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.id, for: indexPath) as? MainViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item)
            return cell
        })

        viewModel.pokemonList
            .map { [SectionModel(model: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

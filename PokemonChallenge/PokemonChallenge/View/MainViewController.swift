//
//  MainViewController.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/13/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - Typealiases
    typealias Section = SectionModel<String, MainViewModel.PokemonItem>
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkRed
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.id)
        collectionView.register(MainHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MainHeaderView.id)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = .mainRed
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // Section: Grid of 3 columns with header
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 3),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0 / 3)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            group.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
            // Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
    
    // MARK: - Binding
    private func bind() {
        let dataSource = makeDataSource()
        
        viewModel.pokemonList
            .map { [Section(model: "Pokemon", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(MainViewModel.PokemonItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                let detailVC = DetailViewController(pokemonID: item.id)
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)

        observeScrollForPagination()
    }
    
    private func makeDataSource() -> RxCollectionViewSectionedReloadDataSource<Section> {
        return RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { _, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainViewCell.id, for: indexPath
                ) as? MainViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: item)
                return cell
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                guard kind == UICollectionView.elementKindSectionHeader,
                      let header = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: MainHeaderView.id,
                        for: indexPath
                      ) as? MainHeaderView else {
                    return UICollectionReusableView()
                }
                return header
            }
        )
    }
    
    private func observeScrollForPagination() {
        collectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let threshold = collectionView.contentSize.height - collectionView.frame.size.height - 100
                if collectionView.contentOffset.y > threshold {
                    self.viewModel.fetchMorePokemon()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Colors
extension UIColor {
    static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
    static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
    static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}

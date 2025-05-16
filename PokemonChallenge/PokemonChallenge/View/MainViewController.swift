//
//  ViewController.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/13/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

// final 키워드를 통해 더 이상 상속이 필요없음을 명시
final class MainViewController: UIViewController {
    
    // 타입에 별칭을 붙임 <각섹션을 구분하기 위한 식별자나 제목으로 사용, 실제 셀에 표현될 데이터 모델>
    typealias Section = SectionModel<String, Result>
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 3),  // 각 셀 너비 1/3
                heightDimension: .fractionalHeight(1.0))         // 높이 고정
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0 / 3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            group.contentInsets = .init(top: 6, leading: 8, bottom: 6, trailing: 8)

            let section = NSCollectionLayoutSection(group: group)
            
            // 헤더 뷰 등록
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
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            navigationController?.isNavigationBarHidden = true
        }
    
    private func configureUI() {
        view.backgroundColor = .mainRed
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .darkRed
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.id)
        collectionView.register(MainHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MainHeaderView.id)
    }
    
    private func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<Section>(
            configureCell: { _, collectionView, indexPath, item in
                print(" 셀 구성 중 indexPath: \(indexPath.row)")
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MainViewCell.id, for: indexPath
                ) as? MainViewCell else {
                    print(" 셀 캐스팅 실패")
                    return UICollectionViewCell()
                }
                cell.configure(with: item)
                return cell
            },
            configureSupplementaryView: { dataSources, collectionView, kind, indexPath in
                guard kind == UICollectionView.elementKindSectionHeader,
                      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: MainHeaderView.id,
                                                                                   for: indexPath) as? MainHeaderView else {
                    return UICollectionReusableView()
                }
                return header
            }
        )
        print("📌 바인딩 시작")
        viewModel.pokemonList
            .map { items -> [Section] in
                print("바인딩 전 아이템 수: \(items.count)")
                return [Section(model: "Pokemon", items: items)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// 사용한 컬러 hex 값.
extension UIColor {
    static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
    static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
    static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}

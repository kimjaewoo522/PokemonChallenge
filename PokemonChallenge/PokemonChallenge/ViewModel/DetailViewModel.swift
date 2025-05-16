//
//  DetailViewModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {
    
    let pokemonDetail = PublishRelay<Detail>()
    private let disposeBag = DisposeBag()
    
    func fetchDetail(id: String) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: urlString) else {
            print("❌ URL 생성 실패")
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (detail: Detail) in
                self?.pokemonDetail.accept(detail)
            }, onFailure: { error in
                print("❌ 포켓몬 디테일 로딩 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

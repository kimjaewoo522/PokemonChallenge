//
//  MainViewModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    /*
    PublishRelay 초깃값을 가지지 않으며, 구독을 시작했어도 최근에 방출된 값을 받지 않는다, 구독이후로 흐른값만을 받아봄
     View에서 이 값을 구독하여 UI를 업데이트함
    */
    let pokemonList = BehaviorRelay<[Result]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokemonList(limit: 20, offset: 0)
    }
    
    func fetchPokemonList(limit: Int, offset: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL")
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: Main) in
                // 응답받은 포켓몬 리스트를 pokemonList Relay에 전달
                self?.pokemonList.accept(response.results)
                print("데이터 수: \(response.results.count)")
            }, onFailure: { error in
                print("네트워크 오류")
            })
            .disposed(by: disposeBag)
    }
    
}

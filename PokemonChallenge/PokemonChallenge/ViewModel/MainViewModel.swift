//
//  MainViewModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/15/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class MainViewModel {
    
    struct PokemonItem {
        let id: String
        let name: String
        let imageURL: String?
    }
    
    let pokemonList = PublishRelay<[PokemonItem]>()
    private let disposeBag = DisposeBag()
    
    init() {
        fetchPokemonList(limit: 20, offset: 0)
    }
    
    private func fetchPokemonList(limit: Int, offset: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            print("❌ 잘못된 URL")
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .flatMap { (main: Main) -> Single<[PokemonItem]> in
                let items = main.results.map { result -> Single<PokemonItem> in
                    guard let id = result.url.split(separator: "/").last else {
                        return .just(PokemonItem(id: "0", name: result.name, imageURL: nil))
                    }
                    
                    let detailURL = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
                    return NetworkManager.shared.fetch(url: detailURL)
                        .map { (detail: Detail) -> PokemonItem in
                            let imageURL = detail.sprites.other.officialArtwork.frontDefault
                            return PokemonItem(id: String(detail.id), name: detail.name, imageURL: imageURL)
                        }
                    .catchAndReturn(PokemonItem(id: String(id), name: result.name, imageURL: nil))                }
                return Single.zip(items)
            }
            .subscribe(onSuccess: { [weak self] items in
                self?.pokemonList.accept(items)
            }, onFailure: { error in
                print("❌ 포켓몬 리스트 로딩 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

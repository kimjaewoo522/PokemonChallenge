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

    let pokemonList = BehaviorRelay<[PokemonItem]>(value: [])
    private let disposeBag = DisposeBag()

    private var offset = 0
    private var isLoading = false
    private let limit = 20

    init() {
        fetchPokemonList(limit: limit, offset: offset)
    }

    func fetchMorePokemon() {
        guard !isLoading else { return }
        offset += limit
        fetchPokemonList(limit: limit, offset: offset)
    }

    private func fetchPokemonList(limit: Int, offset: Int) {
        isLoading = true

        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            print("❌ 잘못된 URL")
            isLoading = false
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
                        .catchAndReturn(PokemonItem(id: String(id), name: result.name, imageURL: nil))
                }
                return Single.zip(items)
            }
            .subscribe(onSuccess: { [weak self] items in
                guard let self = self else { return }
                let newList = self.pokemonList.value + items
                self.pokemonList.accept(newList)
                self.isLoading = false
            }, onFailure: { [weak self] error in
                print("❌ 포켓몬 리스트 로딩 실패: \(error)")
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}

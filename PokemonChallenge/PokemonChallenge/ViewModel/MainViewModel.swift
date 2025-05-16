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
        loadPokemonList(offset: offset)
    }

    func fetchMorePokemon() {
        guard !isLoading else { return }
        offset += limit
        loadPokemonList(offset: offset)
    }

    private func loadPokemonList(offset: Int) {
        isLoading = true

        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            isLoading = false
            return
        }

        NetworkManager.shared.fetch(url: url)
            .flatMap { (main: Main) in
                self.parsePokemonItems(from: main.results)
            }
            .subscribe(onSuccess: { [weak self] items in
                guard let self = self else { return }
                let newList = self.pokemonList.value + items
                self.pokemonList.accept(newList)
                self.isLoading = false
            }, onFailure: { [weak self] error in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }

    private func parsePokemonItems(from results: [Result]) -> Single<[PokemonItem]> {
        let items = results.map { result -> Single<PokemonItem> in
            guard let id = result.url.split(separator: "/").last else {
                return .just(PokemonItem(id: "0", name: result.name, imageURL: nil))
            }
            let detailURL = self.makeDetailURL(for: String(id))
            return NetworkManager.shared.fetch(url: detailURL)
                .map { (detail: Detail) -> PokemonItem in
                    let imageURL = detail.sprites.other.officialArtwork.frontDefault
                    return PokemonItem(id: String(detail.id), name: detail.name, imageURL: imageURL)
                }
                .catchAndReturn(PokemonItem(id: String(id), name: result.name, imageURL: nil))
        }
        return Single.zip(items)
    }

    private func makeDetailURL(for id: String) -> URL {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
    }
}

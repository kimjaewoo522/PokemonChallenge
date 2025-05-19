import RxSwift
import RxCocoa
import UIKit

final class MainViewModel {
    
    let pokemonList = BehaviorRelay<[Detail]>(value: [])
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

    private func parsePokemonItems(from results: [Result]) -> Single<[Detail]> {
        let items = results.map { result -> Single<Detail> in
            guard let id = result.url.split(separator: "/").last else {
                return .just(Detail(id: 0, name: result.name, height: 0, weight: 0, types: [], sprites: Sprites(other: OtherSprites(officialArtwork: OfficialArtwork(frontDefault: nil)))))
            }
            let detailURL = self.makeDetailURL(for: String(id))
            return NetworkManager.shared.fetch(url: detailURL)
                .catchAndReturn(Detail(id: Int(id) ?? 0, name: result.name, height: 0, weight: 0, types: [], sprites: Sprites(other: OtherSprites(officialArtwork: OfficialArtwork(frontDefault: nil)))))
        }
        return Single.zip(items)
    }

    private func makeDetailURL(for id: String) -> URL {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
    }
}

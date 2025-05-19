import RxSwift
import RxCocoa
import UIKit

final class DetailViewModel {

    let detail = BehaviorRelay<Detail?>(value: nil)
    let pokemonImage = BehaviorRelay<UIImage?>(value: nil)

    // 구독할 항목
    let translatedId = BehaviorRelay<String?>(value: nil)
    let translatedName = BehaviorRelay<String?>(value: nil)
    let translatedHeight = BehaviorRelay<String?>(value: nil)
    let translatedWeight = BehaviorRelay<String?>(value: nil)
    let koreanTypes = BehaviorRelay<[String]>(value: [])

    private let disposeBag = DisposeBag()

    func fetchDetail(id: String) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: urlString) else { return }

        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (detail: Detail) in
                guard let self = self else { return }
                self.detail.accept(detail)

                // 번역 후 각각의 Relay로 전달
                self.translatedId.accept("No.\(detail.id)")
                self.translatedName.accept(PokemonTranslator.getKoreanName(for: detail.name))
                self.translatedHeight.accept("키: \(Double(detail.height) / 10)m")
                self.translatedWeight.accept("몸무게: \(Double(detail.weight) / 10)kg")
                self.koreanTypes.accept(
                    detail.types.map { PokemonTypeName(rawValue: $0.type.name)?.displayName ?? $0.type.name }
                )

                // 이미지 로딩
                if let imageURLString = detail.sprites.other.officialArtwork.frontDefault,
                   let imageURL = URL(string: imageURLString) {
                    self.loadImage(from: imageURL)
                } else {
                    self.pokemonImage.accept(nil)
                }

            }, onFailure: { error in
            })
            .disposed(by: disposeBag)
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data) {
                self.pokemonImage.accept(image)
            } else {
                self.pokemonImage.accept(nil)
            }
        }.resume()
    }
}

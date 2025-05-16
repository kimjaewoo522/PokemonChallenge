import Foundation
import RxSwift
import RxCocoa
import UIKit

struct TranslatedPokemonDetail {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [TypeElement]
    let koreanTypes: [String]
}

final class DetailViewModel {

    let pokemonDetail = BehaviorRelay<TranslatedPokemonDetail?>(value: nil)
    let pokemonImage = BehaviorRelay<UIImage?>(value: nil)

    private let disposeBag = DisposeBag()

    /// 외부에서 호출하는 디테일 정보 로딩 메서드
    func fetchAndTranslateDetail(id: String) {
        fetchDetail(id: id)
    }

    func fetchDetail(id: String) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: urlString) else {
            print("❌ URL 생성 실패")
            return
        }

        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (detail: Detail) in
                guard let self = self else { return }

                let translated = self.translateDetail(detail)
                self.pokemonDetail.accept(translated)

                guard let imageURLString = detail.sprites.other.officialArtwork.frontDefault,
                      let imageURL = URL(string: imageURLString) else {
                    print("❌ 이미지 URL이 존재하지 않음")
                    self.pokemonImage.accept(nil)
                    return
                }

                self.loadImage(from: imageURL)

            }, onFailure: { error in
                print("❌ 포켓몬 디테일 로딩 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }

    private func translateDetail(_ detail: Detail) -> TranslatedPokemonDetail {
        let translatedTypes = detail.types.compactMap {
            PokemonTypeName(rawValue: $0.type.name)?.displayName
        }
        let translatedName = PokemonTranslator.getKoreanName(for: detail.name)

        return TranslatedPokemonDetail(
            id: detail.id,
            name: translatedName,
            height: detail.height,
            weight: detail.weight,
            types: detail.types,
            koreanTypes: translatedTypes
        )
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let data = data, let image = UIImage(data: data) {
                self.pokemonImage.accept(image)
            } else {
                print("❌ 이미지 다운로드 실패: \(error?.localizedDescription ?? "알 수 없음")")
                self.pokemonImage.accept(nil)
            }
        }.resume()
    }
}

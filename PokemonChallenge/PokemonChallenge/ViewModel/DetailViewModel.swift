import Foundation
import RxSwift
import RxCocoa
import UIKit

final class DetailViewModel {
    
    let pokemonDetail = BehaviorRelay<Detail?>(value: nil)
    let pokemonImage = BehaviorRelay<UIImage?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    func fetchDetail(id: String) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        guard let url = URL(string: urlString) else {
            print("URL 생성 실패")
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (detail: Detail) in
                guard let self = self else { return }
                
                self.pokemonDetail.accept(detail)
                
                if let urlString = detail.sprites.other.officialArtwork.frontDefault,
                   let imageURL = URL(string: urlString) {
                    
                    URLSession.shared.dataTask(with: imageURL) { data, _, error in
                        if let data = data, let image = UIImage(data: data) {
                            self.pokemonImage.accept(image)
                        } else {
                            print("이미지 다운로드 실패: \(error?.localizedDescription ?? "알 수 없음")")
                            self.pokemonImage.accept(nil)
                        }
                    }.resume()
                } else {
                    print("이미지 URL이 존재하지 않음")
                    self.pokemonImage.accept(nil)
                }
                
            }, onFailure: { error in
                print("포켓몬 디테일 로딩 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

# PokemonChallenge

포켓몬 API(PokeAPI)를 활용해 포켓몬 목록을 표시하고, 각 포켓몬의 상세 정보를 MVVM 아키텍처로 구현한 iOS 앱입니다.

## 주요 기능

- 포켓몬 리스트 무한 스크롤
- 포켓몬 상세 정보 조회 (이름, 타입, 키, 몸무게, 이미지)
- 영어 포켓몬 이름과 타입을 한글로 변환
- RxSwift + MVVM 구조로 데이터 흐름 관리

##  기술 스택

| 기술 | 설명 |
|------|------|
| **UIKit** | 전체 UI 구성 |
| **RxSwift / RxCocoa** | 반응형 바인딩 및 비동기 처리 |
| **MVVM** | 뷰와 로직의 명확한 분리 |
| **SnapKit** | AutoLayout 코드 구성 |
| **Kingfisher** | 포켓몬 이미지 로딩 및 캐싱 |
| **PokeAPI** | [https://pokeapi.co](https://pokeapi.co) REST API 활용 |

##  프로젝트 구조

PokemonChallenge
├── App
│   └── AppDelegate.swift              # 앱의 시작 지점
│
├── Common
│   └── NetworkManager.swift          # API 통신을 담당하는 싱글톤 클래스
│
├── Model
│   ├── DetailModel.swift             # 포켓몬 상세 정보 모델
│   ├── MainModel.swift               # 포켓몬 리스트(메인) 모델
│   ├── PokemonKoreanName.swift       # 영어 이름 → 한글 이름 변환 매핑
│   └── PokemonTypeName.swift         # 타입 영문명 → 한글명 변환 Enum
│
├── ViewModel
│   ├── MainViewModel.swift           # 포켓몬 리스트 MVVM 뷰모델
│   └── DetailViewModel.swift         # 포켓몬 상세 화면 MVVM 뷰모델
│
├── View
│   ├── MainViewController.swift      # 메인 포켓몬 리스트 화면
│   ├── MainViewCell.swift            # 포켓몬 셀
│   ├── MainHeaderView.swift          # 리스트 헤더
│   ├── DetailViewController.swift    # 포켓몬 상세 정보 화면
│   └── LaunchScreen.storyboard       # 런치 스크린 설정
│
├── Resources
│   ├── Assets.xcassets               # 이미지 및 색상 리소스
│   └── Info.plist                    # 앱의 설정 정보


## 트러블슈팅

### 1. 타입 이름이 영어로만 나올 때
- 문제: API에서 받은 포켓몬 타입이 영어로 출력되어 사용자에게 친숙하지 않음.
- 해결: `PokemonTypeName` enum을 사용하여 영어 타입명을 한글로 변환함. ViewModel 내에서 변환 로직을 처리하여 View는 한글만 표시되도록 분리.

## 향후 개선사항

- 포켓몬 검색 기능 추가
- 즐겨찾기 기능 도입 및 CoreData 연동
- UI 애니메이션 효과 추가

//
//  DetailModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/14/25.
//

import Foundation

// MARK: - Detail
struct Detail: Decodable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [TypeElement]
    let sprites: Sprites
}

struct Sprites: Decodable {
    let other: OtherSprites
}

struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}


// MARK: - TypeElement
struct TypeElement: Decodable {
    let type: TypeInfo
}

struct TypeInfo: Decodable {
    let name: String
}




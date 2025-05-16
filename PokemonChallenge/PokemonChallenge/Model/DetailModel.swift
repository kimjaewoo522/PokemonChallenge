//
//  DetailViewModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/14/25.
//

import Foundation

// MARK: - Detail
struct Detail: Codable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: [TypeElement]
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
}

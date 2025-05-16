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
    let height: Int
    let weight: Int
    let types: [TypeElement]
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let type: Species
}

struct Species: Codable {
    let name: String
}

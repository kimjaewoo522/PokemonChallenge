//
//  DetailViewModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/14/25.
//

import Foundation

// MARK: - Welcome
struct Detail: Codable {
    let height: Int
    let id: Int
    let name: String
    let species: Species
    let types: [TypeElement]
    let weight: Int
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

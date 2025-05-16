//
//  MainViewModel.swift
//  PokemonChallenge
//
//  Created by 김재우 on 5/14/25.
//

import Foundation

// MARK: - Main
struct Main: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: String
    let url: String
}

//
//  PokemonSetsData.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

struct PokemonSetsData: Codable {
    let data: [SetsData]
}

struct SetsData: Codable {
    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let releaseDate: String
    let updatedAt: String 
    let images: Images
}

struct Images: Codable {
    let symbol: String
    let logo: String
}

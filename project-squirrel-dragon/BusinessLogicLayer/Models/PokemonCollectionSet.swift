//
//  PokemonCollectionSet.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

struct PokemonCollectionSet: BaseModel {
    var model: Any { get
        { return self }
    }


    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let releaseDate: String
    let updatedAt: String // yyyy/mm//dd hh:mm:ss
    let imageSymbol: String
    let imageLogo: String

    
}

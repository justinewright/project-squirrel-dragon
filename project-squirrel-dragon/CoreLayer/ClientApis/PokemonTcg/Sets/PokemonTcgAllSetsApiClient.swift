//
//  PokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

public enum TCGReturnDataTypes {
    case TcgSets
    case TcgCards
}

class PokemonTcgApiClient: PokemonTcgApiClientProtocol {

    private let endPoint: Endpoint!
    private let dataType: TCGReturnDataTypes!
    init(endPoint: Endpoint, forDataType dataType: TCGReturnDataTypes) {
        self.endPoint = endPoint
        self.dataType = dataType
    }

    func fetch(then handler: @escaping ApiClientResultBlock) {
        switch dataType {
        case .TcgCards:
           break
        case .TcgSets:
            URLSession.shared.request(url:  endPoint.makeUrl(),
                                      expecting: PokemonSetsData.self) { handler($0) }
        case .none:
            break
        }
    }
}

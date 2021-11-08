//
//  PokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonTcgApiClient<T:Codable>: PokemonTcgApiClientProtocol {
    typealias Response = T
    private let endPoint: Endpoint!

    init(endPoint: Endpoint) {
        self.endPoint = endPoint
    }

    func fetch(then handler: @escaping PokemonTcgApiClientResultBlock<Response>) {
        URLSession.shared.request(url:  endPoint.makeUrl(),
                                  expecting: Response.self) { result in
            handler(result)
        }
    }
}

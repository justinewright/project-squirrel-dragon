//
//  PokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol {

    private let apiSetsUrlString: String = "https://api.pokemontcg.io/v2/sets"

    func fetch(then handler: @escaping PokemonTcgAllSetsApiClientResultBlock) {
        guard let url = URL(string: apiSetsUrlString) else { return }

        let session = URLSession(configuration: .default)
        let task =  session.dataTask(with: URLRequest(url: url)) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                      handler(.failure(URLError(.badServerResponse)))
                      return
                  }
            do {
                let decodedData = try JSONDecoder().decode(PokemonSetsData.self, from: data!)
                handler(.success(decodedData))
            } catch {
                handler(.failure(URLError(.badServerResponse)))
            }
        }
        task.resume()

    }
}

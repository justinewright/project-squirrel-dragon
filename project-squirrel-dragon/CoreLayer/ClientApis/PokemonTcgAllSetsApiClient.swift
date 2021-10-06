//
//  PokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonTcgAllSetsApiClient: PokemonTcgApiClientProtocol {
    private let APIkey = "9429b091-1eb8-4db3-8e72-50c2ca7bfede"
    private let requestHeaderField = "X-Api-Key"
    private let apiSetsUrlString = "https://api.pokemontcg.io/v2/sets"

    func fetch(then handler: @escaping (Result<PokemonSetsData>) -> Void) {
        guard let url = URL(string: apiSetsUrlString) else { return }

        // adding api key to header
        var request = URLRequest(url: url)
        request.setValue(APIkey, forHTTPHeaderField: requestHeaderField)
        
        let session = URLSession(configuration: .default)
        let task =  session.dataTask(with: request) { data, response, _ in
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

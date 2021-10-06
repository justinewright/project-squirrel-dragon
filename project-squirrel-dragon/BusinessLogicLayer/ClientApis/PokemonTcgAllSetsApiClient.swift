//
//  PokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation
import Combine

class PokemonTcgAllSetsApiClient: PokemonTcgApiClientProtocol {
    private var cancellables = Set<AnyCancellable>()
    private let APIkey = "9429b091-1eb8-4db3-8e72-50c2ca7bfede"
    private let requestHeaderField = "X-Api-Key"
    private let apiSetsUrlString = "https://api.pokemontcg.io/v2/sets"

    func fetch(then handler: @escaping (Result<PokemonSetsData>) -> Void) {
        guard let url = URL(string: apiSetsUrlString) else { return }

        // adding api key to header
        var request = URLRequest(url: url)
        request.setValue(APIkey, forHTTPHeaderField: requestHeaderField)

        URLSession
            .DataTaskPublisher(request: request,
                               session: URLSession(configuration: .default))
            .retry(3)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                          handler(.failure(URLError(.badServerResponse)))
                          throw URLError(.badServerResponse)
                      }
                return element.data
            }
            .decode(type: PokemonSetsData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { print("\($0)")
            }, receiveValue: {  handler(.success($0)) })
            .store(in: &cancellables)
    }
}

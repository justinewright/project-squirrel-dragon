//
//  PokemonTcgAllSetsApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class PokemonTcgAllSetsApiClient: PokemonTcgAllSetsApiClientProtocol {
    private let constants = Constants.PokemonTcgAllSetsApiClientConstants()

    func fetch(then handler: @escaping PokemonTcgAllSetsApiClientResultBlock) {
        guard let url = URL(string: constants.apiSetsUrlString) else { return }

        // adding api key to header
        var request = URLRequest(url: url)
        request.setValue(constants.APIkey, forHTTPHeaderField: constants.requestHeaderField)
        
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

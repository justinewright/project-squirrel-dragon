//
//  URLSession.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/08.
//

import Foundation

extension URLSession {

    func request<T:Codable>(
        url: URL?,
        expecting: T.Type,
        then handler: @escaping (Result<Any, URLError>) -> Void
    ){
        guard let url = url else {
            handler(.failure(URLError(.badURL)))
            return
        }
        let task = dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                      handler(.failure(URLError(.badServerResponse)))
                      return
                  }
            do {
                let decodedData = try JSONDecoder().decode(expecting, from: data)
                handler(.success(decodedData))
            } catch {
                handler(.failure(URLError(.badServerResponse)))
            }
        }
        task.resume()
    }
}

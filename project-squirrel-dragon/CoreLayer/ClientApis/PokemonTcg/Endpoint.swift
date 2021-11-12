//
//  Endpoint.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/08.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems = [URLQueryItem]()

    func makeUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.pokemontcg.io"
        components.path = "/v2/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }

    func fullPath(withChildName name: String) -> String {
        return path + "/" + name
    }

}

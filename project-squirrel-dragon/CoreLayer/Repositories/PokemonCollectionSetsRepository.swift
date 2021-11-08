//
//  PokemonCollectionSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

class TCGPokemonRepository<DataType:Codable>: RepositoryProtocol {
    // MARK: - Properties
    private var error: URLError?

    private var tcgApiClient: PokemonTcgApiClient<DataType>
    private (set) var data: DataType!

    // MARK: - Initialization
    init(apiClient: PokemonTcgApiClient<DataType>) {
        tcgApiClient = apiClient
    }

    // MARK: - Repository Protocol Implementation
    func fetch(then handler: @escaping AnyResultBlock) {
        tcgApiClient.fetch  { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.data = data
                    handler(.success(self?.data ?? []))
                case .failure(let error):
                    self?.error = error
                    handler(.failure(error))
                }
            }
        }
    }

    func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock) {}
    func delete(_ item: Any, then handler: @escaping AnyResultBlock) {}
}

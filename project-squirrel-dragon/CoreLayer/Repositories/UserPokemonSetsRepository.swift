//
//  UserPokemonSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/02.
//

import Foundation

class UserPokemonSetsRepository: RepositoryProtocol {

    // MARK: - Properties
    private var state: RepositoryState = .loading
    private var error: URLError?

    private var firebaseApiClient: FirebaseApiClientProtocol
    private (set) var firebaseSetsData: [UserSetData] = []
    private var firebase: FirebaseApiClientProtocol!
    private var searchPath: String = ""
    private var searchPathID: String = ""
    // MARK: - Initialization
    init(firebaseApiClient: FirebaseApiClientProtocol = FirebaseApiClient()) {
        self.firebaseApiClient = firebaseApiClient
    }

    func setSearchPath(as newPath: String) {
        searchPath = newPath
    }

    // MARK: - Repository Protocol Implementation
    func fetch(then handler: @escaping AnyResultBlock) {
        DispatchQueue.main.async {
            self.firebaseApiClient.get(fromPath: self.searchPath) { result in
                switch result {
                case .success(let items):
                    handler(.success(items))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }

    func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock) {
        DispatchQueue.main.async {
            self.firebaseApiClient.post(data: [postId:item], toPath: self.searchPath) { result in
                switch result {
                case .success(let items):
                    handler(.success(items))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }

    func delete(_ item: Any, then handler: @escaping AnyResultBlock) {
        DispatchQueue.main.async {
            guard let item = item as? String else {
                handler(.failure(URLError(.resourceUnavailable)))
                return
            }
            self.firebaseApiClient.delete(fromPath: "\(self.searchPath)/\(item)") { result in
                switch result {
                case .success(let items):
                    handler(.success(items))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }

}

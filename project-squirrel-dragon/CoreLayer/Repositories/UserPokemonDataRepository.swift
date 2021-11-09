//
//  UserPokemonSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/02.
//

import Foundation
import Firebase

class UserPokemonDataRepository: RepositoryProtocol {
    // MARK: - Properties
    private var error: URLError?

    private var firebaseApiClient: FirebaseApiClientProtocol
    private (set) var data:  Any!
    
    // MARK: - Initialization
    init(firebaseApiClient: FirebaseApiClientProtocol) {
        self.firebaseApiClient = firebaseApiClient
    }

    // MARK: - Repository Protocol Implementation
    func fetch(then handler: @escaping AnyResultBlock) {
        DispatchQueue.main.async {
            self.firebaseApiClient.get() { result in
                switch result {
                case .success(let data):
                    self.updateUserSets(data: data) { handler($0) }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }

    func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock) {
        DispatchQueue.main.async {
            self.firebaseApiClient.post(data: [postId:item]) { result in
                switch result {
                case .success(let data):
                    self.updateUserSets(data: data) { handler($0) }
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
            self.firebaseApiClient.delete(itemWithId: item) { result in
                switch result {
                case .success(let data):
                    self.updateUserSets(data: data) { handler($0) }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }

    private func updateUserSets(data: Any, then handler: @escaping AnyResultBlock) {
        self.data = data
        handler(.success(self.data as Any))
    }

}

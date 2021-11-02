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

    // MARK: - Initialization
    init(firebaseApiClient: FirebaseApiClientProtocol = FirebaseApiClient()) {
        self.firebaseApiClient = firebaseApiClient
    }

    // MARK: - Repository Protocol Implementation
    func fetch(then handler: @escaping AnyResultBlock) {
//        handler
//        firebaseApiClient.get(then: )
        handler(.success(""))
    }

    func post(_ item: Any, then handler: @escaping AnyResultBlock) {
        handler(.success(""))
    }

    func delete(_ item: Any, then handler: @escaping AnyResultBlock) {

    }

}

//
//  UserPokemonSetsRepository.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/02.
//

import Foundation
import Firebase
class UserPokemonSetsRepository: RepositoryProtocol {

    // MARK: - Properties
    private var error: URLError?

    private var firebaseApiClient: FirebaseApiClientProtocol
    private (set) var firebaseSetsData: [UserSetData] = []
    private var firebase: FirebaseApiClientProtocol!
    private var searchPath: String = ""
    
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
                    self.updateUserSets(items: items) { handler($0) }
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
                    self.updateUserSets(items: items) { handler($0) }
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
                    self.updateUserSets(items: items) { handler($0) }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }

    private func updateUserSets(items: Any, then handler: @escaping AnyResultBlock) {
        guard let datas = items as? DataSnapshot else {
            handler(.failure(URLError(.cannotDecodeContentData)))
            return
        }
        self.firebaseSetsData.removeAll()
        datas.children.forEach {
            guard let data =  $0 as? DataSnapshot else {
                handler(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            if let newUserSet = UserSetData(snapshot: data) {
                self.firebaseSetsData.append(newUserSet)
            }
        }
        handler(.success(self.firebaseSetsData))
    }

}

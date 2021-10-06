//
//  RepositoryContracts.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation

enum RepositoryState {
    case loading
    case success
    case error
}

protocol RepositoryProtocol {
    var state: RepositoryState { get }

    func fetch()
}

protocol ViewModelToRepositoryProtocol {
    func fetchedData() -> BaseModel
}

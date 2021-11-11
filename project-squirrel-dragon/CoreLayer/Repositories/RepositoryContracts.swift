//
//  RepositoryContracts.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/06.
//

import Foundation


protocol RepositoryProtocol {
    func fetch(itemWithID itemID: String, then handler: @escaping AnyResultBlock)
    func fetch(then handler: @escaping AnyResultBlock)
    func post(_ item: Any, withPostId postId: String, then handler: @escaping AnyResultBlock)
    func delete(_ item: Any, then handler: @escaping AnyResultBlock)
}

typealias AnyResultBlock = (Result<Any, URLError>) -> Void

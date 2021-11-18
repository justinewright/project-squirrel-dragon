//
//  FirebaseApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/27.
//

import Foundation

protocol FirebaseApiClientProtocol {
    func post(data: [String: Any], then handler: @escaping AnyResultBlock)
    func get(then handler: @escaping AnyResultBlock)
    func delete(itemWithId itemID: String, then handler: @escaping AnyResultBlock)
}

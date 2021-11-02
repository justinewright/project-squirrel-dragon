//
//  FirebaseApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/27.
//

import Foundation

protocol FirebaseApiClientProtocol {
    func post(data: [String: Any], toPath path: String, then handler: @escaping AnyResultBlock)
    func get(fromPath path: String, then handler: @escaping AnyResultBlock)
    func delete(fromPath path: String, then handler: @escaping AnyResultBlock)
}

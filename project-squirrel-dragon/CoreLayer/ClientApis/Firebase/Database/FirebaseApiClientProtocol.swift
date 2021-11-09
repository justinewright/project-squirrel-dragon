//
//  FirebaseApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/27.
//

import Foundation


protocol FirebaseApiClientProtocol {
    associatedtype Response: Codable
    func post(data: [String: Any], then handler: @escaping ApiClientResultBlock<FirebaseData<Response>>)
    func get(then handler: @escaping ApiClientResultBlock<FirebaseData<Response>>)
    func delete(itemWithId itemID: String, then handler: @escaping ApiClientResultBlock<FirebaseData<Response>>)
}

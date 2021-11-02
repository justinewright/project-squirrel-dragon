//
//  FirebaseApiClientProtocol.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/27.
//

import Foundation

typealias FirebaseApiClientResultBlock = (Result<UserSetData, URLError>) -> Void

protocol FirebaseApiClientProtocol {
    func post(then handler: @escaping FirebaseApiClientResultBlock)
    func get(then handler: @escaping FirebaseApiClientResultBlock)
}

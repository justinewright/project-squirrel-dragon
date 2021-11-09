//
//  Firebase+Extension.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/11/08.
//

import Firebase
import Foundation
import SwiftUI

extension DataSnapshot {
    func snapshotToFirebaseDataModel<T: Codable> (
        expecting: T.Type,
        then handler: @escaping(Result<FirebaseData<T>, URLError>) -> Void) {
            guard let object = children.allObjects as? [DataSnapshot] else {
                handler(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            do {
                let dict: [NSDictionary] = object.compactMap { $0.value as? NSDictionary }
                let jsonData: Data = try JSONSerialization.data(withJSONObject: dict, options: [])
                let results = try JSONDecoder().decode([T].self, from: jsonData)
                handler(.success(FirebaseData(id: "", data: results)))
            } catch {
                handler(.failure(URLError(.cannotDecodeContentData)))
            }
        }
}



extension Data {
    var string: String? {String(data: self, encoding: .utf8)}
}

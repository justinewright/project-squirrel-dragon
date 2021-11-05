//
//  FirebaseApiClient.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/27.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
import Firebase

class FirebaseApiClient: FirebaseApiClientProtocol {

    private var databaseRef: DatabaseReference = Database.database().reference()
    private var sets = [UserSetData]()

    init() {
        databaseRef = Database.database().reference()
    }

    func post(data: [String: Any], toPath path: String, then handler: @escaping AnyResultBlock) {

        guard let autoId = Auth.auth().currentUser,
        let setId = data.keys.first else {
            handler(.failure(URLError(.cannotCreateFile)))
             return
         }
        self.databaseRef.ref.child(autoId.uid).child(path).observeSingleEvent(of: .value, with: { snapshot in

            if snapshot.hasChild(setId) {
                self.update(data: data, toPath: path, withSnapshot: snapshot) { handler($0) }
            } else {
                self.create(data: data, toPath: path, then: { handler($0)})
            }
        })

    }

    func get(fromPath path: String, then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
            handler(.failure(URLError(.userAuthenticationRequired)))
            return
        }
        databaseRef.child("\(autoId.uid)/\(path)").getData(completion:  { error, snapshot in
            guard error == nil else {
                handler(.failure(URLError(.badURL)))
                return
            }
            handler(.success(snapshot))
        })
    }

    func delete(fromPath path: String, then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        databaseRef.child("\(autoId.uid)/\(path)").removeValue { (error:Error?, ref:DatabaseReference) in
            guard error == nil else {
                handler(.failure(URLError(.cannotCreateFile)))
                return
            }
            let temp_path = path.components(separatedBy: "/")[0]
            self.get(fromPath: temp_path) { result in
                handler(result)
            }
        }
    }
}

private extension FirebaseApiClient {

    func update(data: [String: Any], toPath path: String, withSnapshot snapshot: DataSnapshot, then handler: @escaping AnyResultBlock) {

        guard let setId = data.keys.first,
        let value = data.values.first else {
            return handler(.failure(URLError(.cannotCreateFile)))
        }

        snapshot.ref.updateChildValues([setId:value]) { (error:Error?, ref:DatabaseReference) in
            guard error == nil else {
                handler(.failure(URLError(.cannotCreateFile)))
                return
            }
            handler(.success(ref))
        }
    }

    func create(data: [String: Any], toPath path: String, then handler: @escaping AnyResultBlock) {

        guard let autoId = Auth.auth().currentUser,
        let setId = data.keys.first,
        let value = data.values.first else {
            handler(.failure(URLError(.cannotCreateFile)))
            return
        }

        databaseRef.ref.child(autoId.uid).child(path).child(setId).setValue(value) {
            (error:Error?, ref:DatabaseReference) in
            guard error == nil else {
                handler(.failure(URLError(.cannotCreateFile)))
                return
            }
            self.get(fromPath: path) { result in
                handler(result)
            }
        }
    }

}

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

public enum UserReturnDataTypes {
    case UserSets
    case UserCards
}

class FirebaseApiClient: FirebaseApiClientProtocol {

    private var databaseRef: DatabaseReference = Database.database().reference()
    private var dataType: UserReturnDataTypes!
    private let endPoint: Endpoint!

    init(endPoint: Endpoint, forDataType dataType: UserReturnDataTypes) {
        databaseRef = Database.database().reference()
        self.endPoint = endPoint
        self.dataType = dataType
    }

    func post(data: [String: Any], then handler: @escaping AnyResultBlock) {

        guard let autoId = Auth.auth().currentUser,
        let setId = data.keys.first else {
            handler(.failure(URLError(.cannotCreateFile)))
             return
         }
        self.databaseRef.ref.child(autoId.uid).child(endPoint.path).observeSingleEvent(of: .value, with: { snapshot in

            if snapshot.hasChild(setId) {
                self.update(data: data, withSnapshot: snapshot) { handler($0) }
            } else {
                self.create(data: data, then: { handler($0)})
            }
        })

    }

    func get(then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
            handler(.failure(URLError(.userAuthenticationRequired)))
            return
        }
        databaseRef.child("\(autoId.uid)/\(endPoint.path)").getData(completion:  { error, snapshot in
            guard error == nil else {
                handler(.failure(URLError(.badURL)))
                return
            }
            self.convertToDataModel(snapshot: snapshot) { handler($0) }
        })
    }

    func delete(itemWithId itemID: String, then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        databaseRef.child("\(autoId.uid)/\(endPoint.fullPath(withChildName: itemID))").removeValue { (error:Error?, ref:DatabaseReference) in
            guard error == nil else {
                handler(.failure(URLError(.cannotCreateFile)))
                return
            }
            self.get() { handler($0) }
        }
    }
}

private extension FirebaseApiClient {

    func update(data: [String: Any], withSnapshot snapshot: DataSnapshot, then handler: @escaping AnyResultBlock) {

        guard let setId = data.keys.first,
        let value = data.values.first else {
            return handler(.failure(URLError(.cannotCreateFile)))
        }

        snapshot.ref.updateChildValues([setId:value]) { (error:Error?, ref:DatabaseReference) in
            guard error == nil else {
                handler(.failure(URLError(.cannotCreateFile)))
                return
            }
            self.get() { handler($0) }
        }
    }

    func create(data: [String: Any], then handler: @escaping AnyResultBlock) {

        guard let autoId = Auth.auth().currentUser,
        let setId = data.keys.first,
        let value = data.values.first else {
            handler(.failure(URLError(.cannotCreateFile)))
            return
        }

        databaseRef.ref.child(autoId.uid).child(endPoint.path).child(setId).setValue(value) {
            (error:Error?, ref:DatabaseReference) in
            guard error == nil else {
                handler(.failure(URLError(.cannotCreateFile)))
                return
            }
            self.get() { handler($0) }
        }
    }

    private func convertToDataModel(snapshot: DataSnapshot, then handler: @escaping AnyResultBlock) {
        switch dataType {
        case .UserSets:
            snapshot.snapshotToFirebaseDataModel(expecting: UserSetData.self) { response in
                handler(response)
            }
        case .UserCards:
            snapshot.snapshotToFirebaseDataModel(expecting: UserCardData.self) { response in
                handler(response)
            }
        case .none:
            break
        }
    }

}

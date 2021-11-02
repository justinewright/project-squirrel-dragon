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

        guard let autoId = Auth.auth().currentUser else {
             return
         }
        // check if path exists already
        databaseRef.child(autoId.uid).observeSingleEvent(of: .value, with: { snapshot in
            // update path
            if snapshot.hasChild(path) {
                self.databaseRef.updateChildValues([path: data]) {
                    (error:Error?, ref:DatabaseReference) in
                     if let error = error {
                       print("Data could not be saved: \(error).")
                         handler(.failure(URLError(.cannotCreateFile)))
                     } else {
                       print("Data updated successfully!")
                         handler(.success(""))
                     }
                }
            } else {
                // create new path
                let fullPath = "\(autoId.uid)/\(path)"
                self.databaseRef.child(fullPath).setValue(data) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                      print("Data could not be saved: \(error).")
                        handler(.failure(URLError(.cannotCreateFile)))
                    } else {
                      print("Data updated successfully!")
                        handler(.success(""))
                    }
                }
            }
        })

    }

    func get(fromPath path: String, then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        databaseRef.child("\(autoId.uid)/\(path)").getData(completion:  { error, snapshot in
          guard error == nil else {
              handler(.failure(URLError(.cannotCreateFile)))
              print(error!.localizedDescription)
              return
          }
            let decodedData = snapshot.value as? NSDictionary ?? [:]
            handler(.success(decodedData))
        })
    }

    func delete(fromPath path: String, then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        databaseRef.child("\(autoId.uid)/\(path)").removeValue()
    }

}

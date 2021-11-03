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
        let setid = data.keys.first!
        self.databaseRef.ref.child(autoId.uid).child(path).observeSingleEvent(of: .value, with: { snapshot in
            // update path
            if snapshot.hasChild(setid) {
                snapshot.ref.updateChildValues([setid:data.values.first!]) {
                    (error:Error?, ref:DatabaseReference) in
                     if let error = error {
                       print("Data could not be saved: \(error).")
                         handler(.failure(URLError(.cannotCreateFile)))
                     } else {

                       print("Data updated successfully!")
                         handler(.success(ref))
                     }
                }
            } else {
                // create new path

                self.databaseRef.ref.child(autoId.uid).child(path).child(data.keys.first!).setValue(data.values.first!) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                      print("Data could not be saved: \(error).")
                        handler(.failure(URLError(.cannotCreateFile)))
                    } else {
                        self.get(fromPath: path) { result in
                            handler(result)
                        }
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
            handler(.success(snapshot))
        })
    }

    func delete(fromPath path: String, then handler: @escaping AnyResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        databaseRef.child("\(autoId.uid)/\(path)").removeValue { (error:Error?, ref:DatabaseReference) in
            if let error = error {
              print("Data could not be saved: \(error).")
                handler(.failure(URLError(.cannotCreateFile)))
            } else {
              print("Data updated successfully!")
                let temp_path = path.components(separatedBy: "/")[0]
                print(temp_path)
                self.get(fromPath: temp_path) { result in
                    handler(result)
                }
            }
        }
    }

}

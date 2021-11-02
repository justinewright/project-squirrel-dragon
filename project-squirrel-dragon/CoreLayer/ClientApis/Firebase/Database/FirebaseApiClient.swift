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
    private var ref: DatabaseReference = Database.database().reference()
    private var sets = [UserSetData]()

    init() {
        ref = Database.database().reference()
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        ref.child("\(autoId)").observe(DataEventType.value, with: { snapshot in

            if let successfulValue = snapshot.value as? UserSetData {
                print("yay")
            }
    })
    }


    func post(then handler: @escaping FirebaseApiClientResultBlock) {
        guard let autoId = Auth.auth().currentUser else {
             return
         }
        var userSet =  DummyData.userSetData
        userSet.id = "\(autoId.uid)"

        do {
            let jsonData = try JSONEncoder().encode(userSet)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try ref.child("\(userSet.id)").setValue(jsonString)

        } catch let error {
            print(error.localizedDescription)
            handler(.failure(URLError(.userAuthenticationRequired)))
            return
        }

//        guard let user = Firebase.Auth().currentUser else {
//            handler(.failure(URLError(.userAuthenticationRequired)))
//            return
//        }
//        ref.child("\(user.uid)/sets").setValue("sets": DummyData.pokemonSetData)
    }

    func get(then handler: @escaping FirebaseApiClientResultBlock) {

    }


}

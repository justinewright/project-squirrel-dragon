//
//  AnonymousAuthenticator.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import Foundation
#if canImport(FirebaseAuth)
import FirebaseAuth
import Firebase
#endif

class AnonymousAuthenticator: AuthenticationService {
    func signIn(then handler: @escaping AuthResultBlock) {
        let auth = Auth.auth()
        auth.signInAnonymously { (authResult, error) in
            DispatchQueue.main.async {
                guard let user = authResult?.user else {
                    handler(.failure(error!))
                    return
                }
                handler(.success(user))
            }
        }
    }

    func signOut(then handler: @escaping AuthResultBlock) {
        let auth = Auth.auth()
        DispatchQueue.main.async {
            do {
                try auth.signOut()
                handler(.success(nil))
            } catch (let error) {
                handler(.failure(error))
            }
        }

    }

    func currentUser() -> User? {
        Auth.auth().currentUser
    }

}

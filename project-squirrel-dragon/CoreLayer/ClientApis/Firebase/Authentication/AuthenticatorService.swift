//
//  AuthenticatorService.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import Foundation
#if canImport(FirebaseAuth)
import FirebaseAuth
import Firebase
#endif

typealias AuthResultBlock = (Result<User?, Error>) -> Void

protocol AuthenticationService {
    func signIn(then handler: @escaping AuthResultBlock)

    func signOut(then handler: @escaping AuthResultBlock)

    func currentUser() -> User?

}

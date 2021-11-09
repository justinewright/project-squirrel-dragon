//
//  AppState.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import Foundation

final class AppState {
    private(set) var isSignedIn = false

    private var authenticationService: AuthenticationService

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        checkSignInStatus()
    }

    func checkSignInStatus() {
        isSignedIn = authenticationService.currentUser() != nil
    }
}

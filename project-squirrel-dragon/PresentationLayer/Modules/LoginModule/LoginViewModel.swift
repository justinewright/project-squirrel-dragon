//
//  LoginViewModel.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func showHomePage()
    func showError(withMessage message: String)
}

class LoginViewModel {
    // MARK: - Properties
    private var authService: AuthenticationService
    private weak var delegate: LoginViewModelDelegate?

    // MARK: - Initialization
    init(authService: AuthenticationService, delegate: LoginViewModelDelegate? = nil) {
        self.authService = authService
        self.delegate = delegate
    }

    func signIn() {
        guard let delegate = delegate else {
            return
        }
        authService.signIn { result in
            switch result {
            case .success(_):
                delegate.showHomePage()
            case .failure(let error):
                delegate.showError(withMessage: error.localizedDescription)
            }
        }
    }
}

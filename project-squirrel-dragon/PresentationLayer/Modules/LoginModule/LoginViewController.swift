//
//  LoginViewController.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/10/26.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var messageTitle = "Could not login!"
    private lazy var viewModel = LoginViewModel(authService: AnonymousAuthenticator(), delegate: self)
    
    // MARK: - Gestures
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        viewModel.signIn()
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    private func GotoHomePage() {
        let destination = HomePageBuilder.build()
        present(destination, animated: true, completion: nil)

    }

}

// MARK: - LoginViewModel Delegate Methods
extension LoginViewController: LoginViewModelDelegate {

    func showHomePage() {
        activityIndicator.stopAnimating()
        GotoHomePage()
    }

    func showError(withMessage message: String) {
        activityIndicator.stopAnimating()
        showErrorAlert(titled: messageTitle, with: message)
    }

}

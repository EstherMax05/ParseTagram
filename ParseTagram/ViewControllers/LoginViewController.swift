//
//  LoginViewController.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/17/20.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBAction func signInTapped(_ sender: UIButton) {
        errorLabel.text = ""
        if let username = usernameTextField.text, let password = passwordTextField.text {
            login(with: username, and: password)
        } else {
            errorLabel.text = LoginViewControllerConstants.signInErrorText
        }
    }
    @IBAction func signUpTapped(_ sender: UIButton) {
        errorLabel.text = ""
        if let username = usernameTextField.text, let password = passwordTextField.text {
            createUser(with: username, and: password)
        } else {
            errorLabel.text = LoginViewControllerConstants.signUpErrorText
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: LoginViewControllerConstants.loggedInDefaultKey) {
            self.performSegue(withIdentifier: LoginViewControllerConstants.homeScreenSegue, sender: nil)
        }
    }
    
    func storeUserLoginState(isLoggedIn: Bool = true) {
        UserDefaults.standard.set(isLoggedIn, forKey: LoginViewControllerConstants.loggedInDefaultKey)
    }
    
    func login(with username: String, and password: String) {
        let loginState = AccountModel.login(with: username, and: password)
        if loginState.success {
            self.storeUserLoginState()
            self.performSegue(withIdentifier: LoginViewControllerConstants.homeScreenSegue, sender: nil)
        } else {
            print(ParseConstants.errorbasis, loginState.error)
            self.errorLabel.text = loginState.error
        }
    }
    
    func createUser(with username: String, and password: String) {
        let createUserState = AccountModel.createUser(with: username, and: password)
        if createUserState.success {
            self.storeUserLoginState()
            self.performSegue(withIdentifier: LoginViewControllerConstants.homeScreenSegue, sender: nil)
        } else {
            print(ParseConstants.errorbasis, createUserState.error)
            self.errorLabel.text = createUserState.error
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

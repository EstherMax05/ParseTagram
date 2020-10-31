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
        if let username = usernameTextField.text, let password = passwordTextField.text{
            AccountModel.login(with: username, and: password)
        } else {
            errorLabel.text = LoginViewControllerConstants.signInErrorText
        }
    }
    @IBAction func signUpTapped(_ sender: UIButton) {
        errorLabel.text = ""
        if let username = usernameTextField.text, let password = passwordTextField.text {
            AccountModel.createUser(with: username, and: password)
        } else {
            errorLabel.text = LoginViewControllerConstants.signUpErrorText
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: Notification.Name(loggedInNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: Notification.Name(signedUpNotificationKey), object: nil)
    }
    
    @objc func login(_ loginNotification: NSNotification) {
        if let loginStatusDict = loginNotification.userInfo as NSDictionary? {
            if let loginStatus = loginStatusDict[wasSuccessfulKey] as? Bool {
                if loginStatus {
                    self.performSegue(withIdentifier: LoginViewControllerConstants.homeScreenSegue, sender: nil)
                } else if let errorMessage = loginStatusDict[errorReturnedKey] as? String {
                    errorLabel.text = errorMessage
                }
            }
        }
    }

}

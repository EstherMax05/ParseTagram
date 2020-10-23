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
            errorLabel.text = "To sign in, please type in your username and password"
        }
    }
    @IBAction func signUpTapped(_ sender: UIButton) {
        errorLabel.text = ""
        if let username = usernameTextField.text, let password = passwordTextField.text {
            createUser(with: username, and: password)
        } else {
            errorLabel.text = "To sign up, please type in your username and password"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "loggedIn") {
            self.performSegue(withIdentifier: "homeScreenSegue", sender: nil)
        }
    }
    
    func createUser(with username: String, and password: String) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackground { (succeeded, error) in
            if let error = error as NSError? {
              let errorString = error.userInfo["error"] as? NSString
              // Show the errorString somewhere and let the user try again.
              print("Error! ", errorString)
                self.errorLabel.text = errorString as String?
            } else {
              // Hooray! Let them use the app now.
                self.storeUserLoginState()
                self.performSegue(withIdentifier: "homeScreenSegue", sender: nil)
            }
        }
    }
    
    func storeUserLoginState(isLoggedIn: Bool = true) {
        UserDefaults.standard.set(isLoggedIn, forKey: "loggedIn")
    }
    
    func login(with username: String, and password: String) {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
              // Do stuff after successful login.
                self.storeUserLoginState()
                self.performSegue(withIdentifier: "homeScreenSegue", sender: nil)
            } else {
              // The login failed. Check error to see why.
                print("Error! ", error?.localizedDescription)
                self.errorLabel.text = error?.localizedDescription as String?
            }
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

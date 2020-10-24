//
//  AccountModel.swift
//  ParseTagram
//
//  Created by Esther Max-Onakpoya on 10/23/20.
//

import Foundation
import Parse

class AccountModel {
    static func createUser(with username: String, and password: String) -> (error: String?, success: Bool) {
        var errorText: String?
        var wasSuccessful = true
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackground { (succeeded, error) in
            if let error = error as NSError? {
                let errorString = error.userInfo[ParseConstants.errorKey] as? NSString
              // Show the errorString somewhere and let the user try again.
                print(ParseConstants.errorbasis, errorString)
                errorText = errorString as String?
                wasSuccessful = false
            }
        }
        return (errorText, wasSuccessful)
    }
    
    static func login(with username: String, and password: String) -> (error: String?, success: Bool)  {
        var errorText: String?
        var wasSuccessful = true
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user == nil {
              // The login failed. Check error to see why.
                print(ParseConstants.errorbasis, error?.localizedDescription)
                errorText = error?.localizedDescription as String?
                wasSuccessful = false
            }
        }
        return (errorText, wasSuccessful)
    }
}

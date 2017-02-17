//
//  AKISignUpView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

let kAKIPredicateEmailFormat = "SELF MATCHES %@"
let kAKIPredicatePasswordFormat = "%d >= %d"

let kAKIPredicateEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
let kAKIPredicateMinimalPasswordLength = 6

let kAKIErrorMessageEnterYourEmail = "Enter your email"
let kAKIErrorMessageEnterYourPassword = "Enter your password"
let kAKIErrorMessageEnterYourName = "Enter your name"

let kAKIErrorMessageEmailIncorrect = "Email is incorrect"
let kAKIErrorMessagePasswordIncorect = "Password is incorrect"

class AKISignUpView: UIView, validateStringWithPredicate {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    
    @IBOutlet var signUpButton: UIButton?
    
    func validateFields() -> Bool {
        guard let email = self.emailTextField?.text else {
//            self.presentAlertErrorMessage(self.kAKIErrorMessageEnterYourEmail, style: .alert)
            return false
        }
        
        guard let password = self.passwordTextField?.text else {
//            self.presentAlertErrorMessage(self.kAKIErrorMessageEnterYourPassword, style: .alert)
            return false
        }
        
        guard (self.nameTextField?.text) != nil else {
//            self.presentAlertErrorMessage(self.kAKIErrorMessageEnterYourName, style: .alert)
            return false
        }
        
        if !self.validateStringWithPredicate(email, predicate: NSPredicate(format: kAKIPredicateEmailFormat, kAKIPredicateEmailRegex)) {
//            self.presentAlertErrorMessage(self.kAKIErrorMessageEmailIncorrect, style: .alert)
            return false
        }
        
        if !self.validateStringWithPredicate(password, predicate: NSPredicate(format: kAKIPredicatePasswordFormat,
                                                                              password.characters.count,
                                                                              kAKIPredicateMinimalPasswordLength))
        {
//            self.presentAlertErrorMessage(self.kAKIErrorMessagePasswordIncorect, style: .alert)
            return false
        }
        
        return true
    }
}

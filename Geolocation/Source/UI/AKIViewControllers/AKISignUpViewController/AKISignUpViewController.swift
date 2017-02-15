//
//  AKISignUpViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class AKISignUpViewController: AKIViewController {
    
    let kAKIPredicateEmailFormat = "SELF MATCHES %@"
    let kAKIPredicatePasswordFormat = "%d >= %d"
    
    let kAKIPredicateEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let kAKIPredicateMinimalPasswordLength = 6
    
    let kAKIErrorMessageEnterYourEmail = "Enter your email"
    let kAKIErrorMessageEnterYourPassword = "Enter your password"
    let kAKIErrorMessageEnterYourName = "Enter your name"
    
    let kAKIErrorMessageEmailIncorrect = "Email is incorrect"
    let kAKIErrorMessagePasswordIncorect = "Password is incorrect"
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        let signUpView = self.signUpView
        
        guard let email = signUpView?.emailTextField?.text else {
            self.presentAlertErrorMessage(kAKIErrorMessageEnterYourEmail, style: .alert)
            return
        }
        
        guard let password = signUpView?.passwordTextField?.text else {
            self.presentAlertErrorMessage(kAKIErrorMessageEnterYourPassword, style: .alert)
            return
        }
        
        guard let name = signUpView?.nameTextField?.text else {
            self.presentAlertErrorMessage(kAKIErrorMessageEnterYourName, style: .alert)
            return
        }
        
        if !self.validateStringWithPredicate(email, predicate: NSPredicate(format: kAKIPredicateEmailFormat, kAKIPredicateEmailRegex)) {
            self.presentAlertErrorMessage(kAKIErrorMessageEmailIncorrect, style: .alert)
            return
        }
        
        if !self.validateStringWithPredicate(password, predicate: NSPredicate(format: kAKIPredicatePasswordFormat,
                                                                              password.characters.count,
                                                                              kAKIPredicateMinimalPasswordLength))
        {
            self.presentAlertErrorMessage(kAKIErrorMessagePasswordIncorect, style: .alert)
            return
        }
        
        let model = AKIUser(email, password: password, name: name)
        self.model = model
        self.signUpContext()
    }
    
    func signUpContext() {
        let context = AKISignUpContext()
        context.model = self.model
        self.setObserver(context)
    }
    
    override func contextDidLoad() {
        print(kAKISuccessfullySignUp)
        self.pushViewController(AKILocationViewController(), model: self.model)
    }
}

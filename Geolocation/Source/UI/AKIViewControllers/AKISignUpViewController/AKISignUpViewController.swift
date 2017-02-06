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
    
    let kAKIAllertErrorMessage = "Enter your email and password"
    let kAKISuccessfullySignUp = "successfully signed up"
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }
    
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
        let email = self.signUpView?.emailTextField?.text
        let password = self.signUpView?.passwordTextField?.text
        if self.validateFields(email!, password: password!) {
//            FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
//                if error == nil {
//                    print(self.kAKISuccessfullySignUp)
//                    _ = self.navigationController?.popViewController(animated: true)
//                } else {
//                    self.presentAlertErrorMessage((error?.localizedDescription)!, style: .alert)
//                }
//            }
            self.signUpContext()
        }
    }
    
    func signUpContext() {
        let context = AKISignUpContext()
        context.model = self.model
        context.performExecute()
    }
}

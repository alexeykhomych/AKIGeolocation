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
        let name = self.signUpView?.nameTextField?.text
        
        if self.validateStringWithPredicate(email!, predicate: NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")) &&
            self.validateStringWithPredicate(password!, predicate: NSPredicate(format: "%d >= 6", password!.characters.count)) {
            let model = AKIUser(email!, password: password!, name: name!)
            self.model = model
            self.signUpContext()
        } else {
            self.presentAlertErrorMessage("Ahtung!", style: .alert)
        }
    }
    
    func signUpContext() {
        let context = AKISignUpContext()
        context.model = self.model
        self.setObserver(context)
    }
    
    override func modelDidLoad() {
        DispatchQueue.main.async {
            print(kAKISuccessfullySignUp)
            self.pushViewController(AKILocationViewController(), model: self.model)
        }
    }
}

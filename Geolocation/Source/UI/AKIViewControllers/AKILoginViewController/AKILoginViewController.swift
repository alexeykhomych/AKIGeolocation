//
//  AKILoginViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import Firebase
import FirebaseAuth

let kAKIAllertTitleOk = "Ok"
let kAKIAllertTitleError = "Error"
let kAKIAllertMessage = ""

class AKILoginViewController: AKIViewController {
    
    var model: AnyObject?
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let facebookLoginButton = FBSDKLoginButton.init()
//        facebookLoginButton.center = self.view.center
//        self.view.addSubview(facebookLoginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginFBButton(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let email = self.loginView?.emailTextField?.text
        let password = self.loginView?.passwordTextField?.text
        
        if email == "" || password == "" {
            let alertController = UIAlertController(title: kAKIAllertTitleError, message: kAKIAllertMessage, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: kAKIAllertTitleOk, style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error == nil {
                    self.pushToViewController(AKILocationViewController())
                } else {
                    let alertController = UIAlertController(title: kAKIAllertTitleError, message: kAKIAllertMessage, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: kAKIAllertTitleError, style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        self.pushToViewController(AKISignUpViewController())
    }
    
    func presentAllert(_ title: String, message: String, preferredStyle: UIAlertControllerStyle) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
//        
//        alertController.addAction(UIAlertAction(title: kAKIAllertTitleOk, style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
    }
}

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

class AKILoginViewController: AKIViewController, FBSDKLoginButtonDelegate {
    
    var model: AnyObject?
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.frame = (self.loginView?.loginWithFBButton?.frame)!
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email", "public_profile"]
        
        self.view.addSubview(facebookLoginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginFBButton(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let email = self.loginView?.emailTextField?.text
        let password = self.loginView?.passwordTextField?.text
        
        if self.validateFields(email!, password: password!) {
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error == nil {
                    self.userDidLogin()
                } else {
                    self.presentAlertErrorMessage(kAKIAllertMessage, style: .alert)
                }
            })
        }
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
        
        print("Successfully logged in with facebook")
        self.userDidLogin()
    }
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        self.userDidLogin()
    }
    
    func userDidLogin() {
        self.pushToViewController(AKILocationViewController())
    }
}

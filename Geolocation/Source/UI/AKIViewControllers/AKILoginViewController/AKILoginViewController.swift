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
        facebookLoginButton.readPermissions = [kAKIFacebookPermissionEmail, kAKIFacebookPermissionPublicProfile]
        
        self.view.addSubview(facebookLoginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let email = self.loginView?.emailTextField?.text
        let password = self.loginView?.passwordTextField?.text
        
        if self.validateFields(email!, password: password!) {
            self.loginWithFirebase()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
        
        print("Successfully logged in with facebook")
        self.loginWithFacebook()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        self.pushViewController(AKISignUpViewController(), model: self.model)
    }
    
    func loginWithFirebase() {
        let context = AKILoginContext()
        context.model = self.model
        self.setObserver(context)
    }
    
    func loginWithFacebook() {
        let context = AKIFacebookLoginContext()
        context.model = self.model
        self.setObserver(context)
    }
    
    override func modelDidLoad() {
        DispatchQueue.main.async {
            self.pushViewController(AKILocationViewController(), model: self.model)
        }
    }
    
    
    
}

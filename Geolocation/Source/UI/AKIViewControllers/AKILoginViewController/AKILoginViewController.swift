//
//  AKILoginViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import FBSDKLoginKit

import Firebase
import FirebaseAuth

class AKILoginViewController: AKIViewController, FBSDKLoginButtonDelegate {
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accessToken = FBSDKAccessToken.current()
        if accessToken != nil {
            let user = AKIUser()
            user.id = accessToken?.userID
            self.model = user
            self.contextDidLoad(AKIFacebookLoginContext(user))
        } else {
            self.model = AKIUser()
        }
        
        self.initFacebookLoginButton()
        self.initLoginButton()
        self.initSignupButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initFacebookLoginButton() {
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.frame = (self.loginView?.loginWithFBButton?.frame)!
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = [kAKIFacebookPermissionEmail, kAKIFacebookPermissionPublicProfile]
        
        self.view.addSubview(facebookLoginButton)
    }
    
    func initLoginButton() {
        self.loginView?.loginButton?.rx.tap
            .debounce(kAKIDebounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let view = self?.loginView
                let model = self?.model as? AKIUser
                
                let email = view?.emailTextField?.text
                let password = view?.passwordTextField?.text
                
                if (email?.isEmpty)! || (password?.isEmpty)! {
                    return
                }
                
                model?.email = email
                model?.password = password
                
                self?.observeFirebaseLoginContext(AKILoginContext(model!))
            }).disposed(by: self.disposeBag)
    }
    
    func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(kAKIDebounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController(), model: self?.model)
            }).disposed(by: self.disposeBag)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
    
        self.observeFacebookLoginContext(AKIFacebookLoginContext(self.model!))
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    
    //MARK: Observing
    
    override func contextDidLoad(_ context: AKIContext) {
        self.pushViewController(AKILocationViewController(), model: context.model)
    }
    
    func observeFacebookLoginContext(_ context: AKIFacebookLoginContext) {
        let observer = context.loginFacebook(context.model)
        _ = observer.subscribe(onNext: { _ in
            
        },onError: { error in
            DispatchQueue.main.async {
                self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }
        },onCompleted: { result in
            DispatchQueue.main.async {
                self.contextDidLoad(context)
            }
        },onDisposed: nil)
    }
    
    func observeFirebaseLoginContext(_ context: AKILoginContext) {
        let observer = context.loginUser(context.model)
        _ = observer.subscribe(onNext: { _ in
            
        },onError: { error in
            DispatchQueue.main.async {
                self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }
        },onCompleted: { result in
            DispatchQueue.main.async {
                self.contextDidLoad(context)
            }
        },onDisposed: nil)
    }
}

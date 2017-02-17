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
            self.contextDidLoad(self.context)
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
                
                self?.loginWithFirebase((self?.model!)!)
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
        
        self.observeContext(AKIFacebookLoginContext(), model: self.model!)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    
    func loginWithFirebase(_ model: AKIModel) {
//        let context = AKILoginContext()
//        context.model = model
//        self.setObserver(context)
    }
    
    //MARK: Observing
    
    
    override func contextDidLoad(_ context: AKIContext) {
        self.pushViewController(AKILocationViewController(), model: context.model)
    }
    
    func observeContext(_ context: AKIFacebookLoginContext, model: AKIModel) {
        let observer = context.loginFacebook(model)
        _ = observer.subscribe(onNext: { _ in
            
        },onError: { error in
            
        },onCompleted: { result in
            self.pushViewController(AKILocationViewController(), model: model)
        },onDisposed: nil)
    }
}

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
        
        self.loginView?.validateFields()
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
                let context = AKILoginContext((self?.model)!)
                self?.observerContext(context, observer: (self?.firebaseObserver(context))!)
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
    
        let context = AKIFacebookLoginContext((self.model)!)
        self.observerContext(context, observer: (self.facebookObserver(context)))
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    
    //MARK: Observing
    
    override func contextDidLoad(_ context: AKIContext) {
        self.pushViewController(AKILocationViewController(), model: context.model)
    }
    
    func facebookObserver(_ context: AKIFacebookLoginContext) -> Observable<AnyObject> {
        return context.loginFacebook()
    }
    
    func firebaseObserver(_ context: AKILoginContext) -> Observable<AnyObject> {
        return context.loginUser()
    }
}

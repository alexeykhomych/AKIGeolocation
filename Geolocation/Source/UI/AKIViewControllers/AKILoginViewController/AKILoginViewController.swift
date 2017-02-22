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

protocol AKIFacebookLogin: FBSDKLoginButtonDelegate {
    
    func loginWithContext()
    func initFacebookLoginButton()
    
}

extension AKIFacebookLogin {
    
    func loginWithAccessToken(_ model: AKIUser) {
        var model = model
        let user = AKIUser()
        let accessToken = FBSDKAccessToken.current()
        
        if accessToken != nil {
            user.id = accessToken?.userID
            model = user
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}

protocol AKIFirebaseLogin {
    
    func loginWithFirebase()
    
}

class AKILoginViewController: AKIViewController, AKIFacebookLogin {
    
    let kAKILogoutButtonText = "Logout"
    let disposeBag = DisposeBag()
    
    private var loginViewModel: AKILoginViewModel?
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initModel()
        
        self.initFacebookLoginButton()
        self.initLoginButton()
        self.initSignupButton()
        self.loginView?.addBindsToViewModel(self.loginViewModel!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initModel() {
        let user = AKIUser()
        let accessToken = FBSDKAccessToken.current()
        
        if accessToken != nil {
            user.id = accessToken?.userID
            model = user
            
        }
        
        self.model = user
    }
    
    func initFacebookLoginButton() {
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.frame = (self.loginView?.loginWithFBButton?.frame)!
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = [Context.Permission.email, Context.Permission.publicProfile]
        
        self.view.addSubview(facebookLoginButton)
    }
    
    func initLoginButton() {
        self.loginView?.loginButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.bindIDToViewModel()
            })
            .disposed(by: self.disposeBag)
    }
    
    func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in

            })
            .disposed(by: self.disposeBag)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    
    internal func loginWithContext() {
        
    }
    
    func bindIDToViewModel() {
        let model = self.loginViewModel
        let id = model?.id.asObservable()
        id?.subscribe( onNext: { result in
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            })
            .disposed(by: self.disposeBag)
    }
    
}

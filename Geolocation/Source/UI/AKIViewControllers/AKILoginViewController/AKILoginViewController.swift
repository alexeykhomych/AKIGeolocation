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
    
    private var loginViewModel: AKILoginViewModel?
    
    var loginView: AKILoginView? {
        return self.getView()
    }
    
    private func addBindsToViewModel(_ loginViewModel: AKILoginViewModel) {
        let loginView:AKILoginView = self.loginView!
        
        loginViewModel.email
            .asObservable()
            .map({ text -> String? in
                return Optional(text)
            })
            .bindTo(loginView.emailTextField.rx.text)
            .addDisposableTo(self.disposeBag)
        
        loginViewModel.password
            .bindTo(loginView.passwordTextField.rx.text)
            .addDisposableTo(self.disposeBag)
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
        self.observForViewModel()
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
                //провести валидацию
                
                //забиндить поля с вьюмодела
                let loginViewModel = AKILoginViewModel(AKILoginContext((self?.model!)!))
                self?.loginViewModel = loginViewModel
                self?.addBindsToViewModel(loginViewModel)
            })
            .disposed(by: self.disposeBag)
    }
    
    func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(kAKIDebounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController(), model: self?.model)
            })
            .disposed(by: self.disposeBag)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
    
        //залогиниться с помощью ФБ, открыть следующий контроллер
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    
    func observForViewModel() {
        let loginViewModel = self.loginViewModel
        //необходимо подписаться на изменения ViewModel
        let temp = loginViewModel?.id.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .shareReplay(1)
        
        _ = temp?.subscribe(onNext: { _ in
            self.pushViewController(AKILocationViewController(), model: self.model)
        })
    }

}

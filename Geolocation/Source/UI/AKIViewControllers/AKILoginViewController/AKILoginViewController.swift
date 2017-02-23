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

protocol AKIFacebookLogin: FBSDKLoginButtonDelegate {
    
    func initFacebookLoginButton()
    func loginWithAccessToken()
    
}

protocol AKIFirebaseLogin {

    func loginWithFirebase()

}

extension AKILoginViewController: AKIFirebaseLogin {

    internal func loginWithFirebase() {
        
    }

}

extension AKILoginViewController: AKIFacebookLogin {
    
    internal func initFacebookLoginButton() {
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.frame = (self.loginView?.loginWithFBButton?.frame)!
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = [Context.Permission.email, Context.Permission.publicProfile]

        self.view.addSubview(facebookLoginButton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginWithAccessToken() {
        let accessToken = FBSDKAccessToken.current()

        if accessToken != nil {
            let model = AKIUser()
            model.id = accessToken?.userID
            self.model = model
        }
    }
}

class AKILoginViewController: UIViewController {

    var model: AKIUser?
    
    let kAKILogoutButtonText = "Logout"
    let disposeBag = DisposeBag()
    
    private var loginViewModel: AKILoginViewModel?
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initModel()
        self.initViewModel()
        
        self.initFacebookLoginButton()
        self.initLoginButton()
        self.initSignupButton()
        
        self.loginWithAccessToken()
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
    
    func initViewModel() {
        self.loginViewModel = AKILoginViewModel(self.model!)
    }
    
    func initLoginButton() {
        self.loginView?.loginButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.doSomething()
            })
            .disposed(by: self.disposeBag)
    }
    
    func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController(), model: (self?.model)!)
            })
            .disposed(by: self.disposeBag)
    }
    
    func doSomething() {
        let model = AKIUser(email: (self.loginView?.emailTextField.text)!,
                            password: (self.loginView?.passwordTextField.text)!,
                            name: "")
        self.model = model
        
        let viewModel = AKILoginViewModel(model)
        
        let id = viewModel.id.asObservable()
        id.subscribe( onCompleted: { result in
            self.pushViewController(AKILocationViewController(), model: model)
        }).disposed(by: self.disposeBag)
    }
    
}

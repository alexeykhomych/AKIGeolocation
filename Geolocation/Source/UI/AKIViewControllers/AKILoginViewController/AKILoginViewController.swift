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

class AKILoginViewController: UIViewController, Tappable, contextObserver {
    
    var userModel: AKIUser?
    
    let disposeBag = DisposeBag()
    
    var loginView: AKILoginView? {
        return self.getView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userModel = AKIUser()
        
        self.loginWithAccessToken()
        
        self.loginView?.addBinds(to: self.userModel!)
        
        self.initLoginButton()
        self.initSignupButton()
        self.initLoginWithFacebookButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginWithAccessToken() {
        _ = AKILoginService(self.userModel).loginWithFacebookAccessToken()
            .subscribe(onNext: { [weak self] userModel in
                    self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
    }
    
    private func initLoginButton() {
        _ = self.loginView?.loginButton?.rx.tap
            .flatMap( { result in
                return AKILoginService(self.userModel).login(LoginServiceType.Firebase)
            })
            .subscribe(onNext: { [weak self] userModel in
                    self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController())
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initLoginWithFacebookButton() {
        _ = self.loginView?.loginWithFBButton?.rx.tap
            .flatMap( { result in
                return AKILoginService(self.userModel).login(LoginServiceType.Facebook)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] userModel in
                self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    func showLocationViewControllerWithViewModel(_ userModel: AKIUser?) {
        let controller = AKILocationViewController()
        controller.userModel = userModel
        self.pushViewController(controller)
    }
}

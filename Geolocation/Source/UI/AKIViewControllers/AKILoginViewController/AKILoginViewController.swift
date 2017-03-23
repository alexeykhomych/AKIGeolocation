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

class AKILoginViewController: UIViewController, Tappable {
    
    // MARK: Accessors
    
    var userModel: AKIUser?
    
    let disposeBag = DisposeBag()
    
    var loginService = AKILoginService()
    
    var loginView: AKILoginView? {
        return self.getView()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userModel = AKIUser()
        self.loginService = AKILoginService()
        
        self.loginWithToken()
        
        self.loginFirebaseButton()
        self.signupButton()
        self.loginFacebookButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Initializations and Deallocations
    
    func loginFirebaseButton() {
        guard let loginView = self.loginView,
        var userModel = self.userModel else { return }
        
        _ = loginView.loginButton?.rx.tap
            .map { _ in
                userModel = loginView.fillModel(userModel)
                
                let isValid = userModel.emailValidation() && userModel.passwordValidation()
                
                if !isValid {
                    self.presentAlertErrorMessage("Your email or password is incorrect", style: .alert)
                }
                
                return isValid
            }
            .filter {
                $0 == true
            }
            .flatMap { _ in
                return self.loginService.login(with: userModel, service: LoginServiceType.Email)
            }
            .subscribe(onNext: { [weak self] userModel in
                    self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    func signupButton() {
        self.loginView?.signUpButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                    self?.pushViewController(AKISignUpViewController())
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    func loginFacebookButton() {
        guard let userModel = self.userModel else { return }
        
        _ = self.loginView?.loginWithFBButton?.rx.tap
            .flatMap( { result in
                return self.loginService.login(with: userModel, service: LoginServiceType.Facebook, viewController: self)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] userModel in
                self?.showLocationViewControllerWithViewModel(userModel)
            }, onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: Private methods
    
    private func showLocationViewControllerWithViewModel(_ userModel: AKIUser?) {
        let controller = AKILocationViewController()
        controller.userModel = userModel
        self.pushViewController(controller)
    }
    
    private func loginWithToken() {
        guard let userModel = self.userModel else { return }
        
        _ = self.loginService.login(with: userModel, service: LoginServiceType.Email)
            .subscribe(onNext: { [weak self] userModel in
                self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
    }
}

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
    
    let disposeBag = DisposeBag()
    
    var loginService = AKILoginService()
    
    var loginView: AKILoginView? {
        return self.getView()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginService = AKILoginService()
        
        self.loginWithToken()
        
        self.loginFirebaseButton()
        self.signupButton()
        self.loginFacebookButton()
    }
    
    // MARK: Initializations and Deallocations
    
    func loginFirebaseButton() {
        guard let loginView = self.loginView else { return }
        let userModel = AKIUser()
        
        _ = loginView.loginButton?.rx.tap
            .map { _ in
                return self.fillModel()
            }
            .filter {
                $0.emailValidate() && $0.passwordValidate()
            }
            .flatMap { _ in
                return self.loginService.login(with: userModel, service: LoginServiceType.email, viewController: self)
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
        _ = self.loginView?.loginWithFBButton?.rx.tap
            .flatMap( { result in
                return self.loginService.login(with: AKIUser(), service: LoginServiceType.facebook, viewController: self)
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
        _ = self.loginService.login(with: AKIUser(), service: LoginServiceType.token, viewController: self)
            .subscribe(onNext: { [weak self] userModel in
                self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
    }
    
    private func fillModel() -> AKIUser {
        var userModel = AKIUser()
        let loginView = self.loginView
        userModel.password = loginView?.passwordTextField?.text ?? ""
        userModel.email = loginView?.emailTextField?.text ?? ""
        
        return userModel
    }
}

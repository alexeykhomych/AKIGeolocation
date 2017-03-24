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

import IDPRootViewGettable

class AKILoginViewController: UIViewController, Tappable, RootViewGettable {
    
    typealias RootViewType = AKILoginView
    
    // MARK: Accessors
    
    let disposeBag = DisposeBag()
    
    var loginService = AKIAuthService()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginWithUser()
        
        self.loginFirebaseButton()
        self.signupButton()
        self.loginFacebookButton()
    }
    
    // MARK: Initializations and Deallocations
    
    func loginFirebaseButton() {
        _ = self.rootView?.loginButton?.rx.tap
            .map { _ in
                self.fill(userModel: AKIUser())
            }
            .filter {
                $0.emailValidate() && $0.passwordValidate()
            }
            .flatMap {
                return self.loginService.login(with: $0, service: LoginServiceType.email, viewController: self)
            }
            .subscribe(onNext: { [weak self] user in
                    self?.showLocationViewControllerWithViewModel(user)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    func signupButton() {
        self.rootView?.signUpButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                    self?.pushViewController(AKISignUpViewController())
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    func loginFacebookButton() {
        let userModel = AKIUser()
        _ = self.rootView?.loginWithFBButton?.rx.tap
            .flatMap {
                return self.loginService.login(with: userModel, service: LoginServiceType.facebook, viewController: self)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.showLocationViewControllerWithViewModel(user)
                }, onError: { [weak self]  error in
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

    private func loginWithUser() {
        _ = self.loginService.login(with: AKIUser(), service: LoginServiceType.email, viewController: self)
            .subscribe(onNext: { [weak self] user in
                self?.showLocationViewControllerWithViewModel(user)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
    }
    
    private func fill(userModel: AKIUser) -> AKIUser {
        var userModel = userModel
        let rootView = self.rootView
        
        userModel.password = rootView?.passwordTextField?.text ?? ""
        userModel.email = rootView?.emailTextField?.text ?? ""
        
        return userModel
    }
}

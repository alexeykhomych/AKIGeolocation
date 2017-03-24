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

import Firebase
import FirebaseAuth

class AKILoginViewController: UIViewController, Tappable, RootViewGettable {
    
    typealias RootViewType = AKILoginView
    
    // MARK: Accessors
    
    let disposeBag = DisposeBag()
    
    var loginService = AKIAuthService()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginService = AKIAuthService()
        
        self.loginWithToken()
        
        self.loginFirebaseButton()
        self.signupButton()
        self.loginFacebookButton()
    }
    
    // MARK: Initializations and Deallocations
    
    func loginFirebaseButton() {
        var userModel = AKIUser()
        
        _ = self.rootView?.loginButton?.rx.tap
            .map { _ in
                userModel = self.fillModel()
                return userModel
            }
            .filter {
                $0.emailValidate() && $0.passwordValidate()
            }
            .flatMap {
                return self.loginService.login(with: $0, service: LoginServiceType.email, viewController: self)
            }
            .subscribe(onNext: { [weak self] firUser in
                    userModel.id = firUser.uid
                    self?.showLocationViewControllerWithViewModel(userModel)
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
        var userModel = AKIUser()
        _ = self.rootView?.loginWithFBButton?.rx.tap
            .flatMap {
                return self.loginService.login(with: userModel, service: LoginServiceType.facebook, viewController: self)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] firUser in
                userModel.id = firUser.uid
                self?.showLocationViewControllerWithViewModel(userModel)
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

    private func loginWithToken() {
        var userModel = AKIUser()
        _ = self.loginService.login(with: AKIUser(), service: LoginServiceType.email, viewController: self)
            .subscribe(onNext: { [weak self] firUser in
                userModel.id = firUser.uid
                self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
    }
    
    private func fillModel() -> AKIUser {
        var userModel = AKIUser()
        let rootView = self.rootView
        
        userModel.password = rootView?.passwordTextField?.text ?? ""
        userModel.email = rootView?.emailTextField?.text ?? ""
        
        return userModel
    }
}

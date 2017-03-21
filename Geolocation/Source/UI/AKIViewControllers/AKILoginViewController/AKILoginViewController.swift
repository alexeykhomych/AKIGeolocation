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
    
    var loginService: AKILoginService?
    
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
    
    private func loginFirebaseButton() {
        guard let loginView = self.loginView else { return }
        
        var userModel = self.userModel
        
        _ = loginView.loginButton?.rx.tap
            .map { _ in
                let tupleResult = loginView.fillModel()
                tupleResult.1 ? userModel = tupleResult.0 : self.presentAlertErrorMessage("Your email or password is incorrect", style: .alert)
                
                return tupleResult.1
            }
            .filter {
                $0 == true
            }
            .flatMap { _ in
                return AKILoginService().login(with: userModel, service: LoginServiceType.Firebase)
            }
            .subscribe(onNext: { [weak self] userModel in
                    self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func signupButton() {
        self.loginView?.signUpButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                    self?.pushViewController(AKISignUpViewController())
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func loginFacebookButton() {
        _ = self.loginView?.loginWithFBButton?.rx.tap
            .flatMap( { result in
                return AKILoginService().login(with: self.userModel, service: LoginServiceType.Facebook)
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
        let userModel = self.userModel ?? AKIUser()
        
        _ = AKILoginService().login(with: userModel, service: LoginServiceType.FirebaseToken)
            .subscribe(onNext: { [weak self] userModel in
                    self?.showLocationViewControllerWithViewModel(userModel)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
    }
}

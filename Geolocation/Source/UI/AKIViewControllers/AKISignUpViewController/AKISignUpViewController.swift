//
//  AKISignUpViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import IDPRootViewGettable

class AKISignUpViewController: UIViewController, RootViewGettable {
    
    typealias RootViewType = AKISignUpView
    
    // MARK: Accessors
    
    let disposeBag = DisposeBag()
    
    var userModel: AKIUser?
    
    var loginService = AKIAuthService()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
    }
    
    // MARK: Initializations and Deallocations
    
    func initSignUpButton() {
        _ = self.rootView?.signUpButton?.rx.tap
            .map { _ in
                self.fill(userModel: AKIUser())
            }
            .filter {
                $0.emailValidate() && $0.passwordValidate() && $0.nameValidate()
            }
            .flatMap {
                self.loginService.signup(with: $0)
            }
            .subscribe(onNext: { [weak self] user in
                    self?.showLocationViewControllerWithViewModel(user)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: Private methods
    
    private func fill(userModel: AKIUser) -> AKIUser {
        var userModel = AKIUser()
        let rootView = self.rootView
        
        userModel.password = rootView?.passwordTextField?.text ?? ""
        userModel.email = rootView?.emailTextField?.text ?? ""
        userModel.name = rootView?.nameTextField?.text ?? ""
        
        return userModel
    }
    
    private func showLocationViewControllerWithViewModel(_ userModel: AKIUser) {
        let controller = AKILocationViewController()
        controller.userModel = userModel
        self.pushViewController(controller)
    }
}

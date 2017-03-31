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

import Result

extension AKISignUpViewController {
    
    func performResult(result: Result<AKIUser, AuthError>) {
        switch result {
        case let .success(user):
            self.segueLocationViewController(with: user)
        case let .failure(error):
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }
    }
    
}

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
            .subscribe(onNext: { [weak self] in
                self?.performResult(result: $0)
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
    
    func segueLocationViewController(with userModel: AKIUser) {
        let controller = AKILocationViewController()
        controller.userModel = userModel
        self.pushViewController(controller)
    }
}

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
        let userModel = AKIUser()
        
        _ = self.rootView?.signUpButton?.rx.tap
            .map { _ in
                self.fillModel()
            }
            .filter {
                $0.emailValidate() && $0.passwordValidate() && $0.nameValidate()
            }
            .flatMap { _ in
                self.loginService.signup(with: userModel)
            }
            .subscribe(onNext: { [weak self] userModel in
                    let controller = AKILocationViewController()
                    controller.userModel = userModel
                    self?.pushViewController(controller)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func fillModel() -> AKIUser {
        var userModel = AKIUser()
        let rootView = self.rootView
        
        userModel.password = rootView?.passwordTextField?.text ?? ""
        userModel.email = rootView?.emailTextField?.text ?? ""
        userModel.name = rootView?.nameTextField?.text ?? ""
        
        return userModel
    }
}

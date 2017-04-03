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

class AKISignUpViewController: UIViewController, RootViewGettable, ViewControllerResult {
    
    typealias RootViewType = AKISignUpView
    
    // MARK: Accessors
    
    private let disposeBag = DisposeBag()
    private var userModel: AKIUser?
    private var loginService = AKIAuthService()
    private let tap = UITapGestureRecognizer()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
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
                self?.performResult(result: $0, block: {
                    self?.segueLocationViewController(with: $0)
                })
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
    
    private func segueLocationViewController(with userModel: AKIUser) {
        let controller = AKILocationViewController()
        controller.userModel = userModel
        self.pushViewController(controller)
    }
    
    private func prepareView() {
        let tap  = self.tap
        tap.addTarget(self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.initSignUpButton()
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

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

import Result

class AKILoginViewController: UIViewController, RootViewGettable, ViewControllerResult {
    
    typealias RootViewType = AKILoginView
    
    // MARK: Accessors
    
    private let disposeBag = DisposeBag()
    private var loginService = AKIAuthService()
    private let tap = UITapGestureRecognizer()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: Initializations and Deallocations
    
    func loginFirebaseButton() {
        _ = self.rootView?.loginButton?.rx.tap
            .debounce(1, scheduler: MainScheduler.instance)
            .map { _ in
                self.fill(userModel: AKIUser())
            }
            .filter {
                $0.emailValidate() && $0.passwordValidate()
            }
            .flatMap {
                self.loginService.login(with: $0, service: .email, viewController: self)
            }
            .observeOn(MainScheduler.instance)
            .bindNext { [weak self] in
                self?.performResult(result: $0, block: {
                    self?.segueLocationViewController(with: $0)
                })
            }
            .disposed(by: self.disposeBag)
    }
    
    func signUpButton() {
        self.rootView?.signUpButton?.rx.tap
            .bindNext { [weak self] in self?.pushViewController(AKISignUpViewController()) }
            .disposed(by: self.disposeBag)
    }
    
    func loginFacebookButton() {
        let userModel = AKIUser()
        _ = self.rootView?.loginWithFBButton?.rx.tap
            .debounce(1, scheduler: MainScheduler.instance)
            .flatMap {
                self.loginService.login(with: userModel, service: .facebook, viewController: self)
            }
            .observeOn(MainScheduler.instance)
            .bindNext { [weak self] in
                self?.performResult(result: $0, block: {
                    self?.segueLocationViewController(with: $0)
                })
            }
            .disposed(by: self.disposeBag)
    }
    
    // MARK: Private methods
    
    func segueLocationViewController(with userModel: AKIUser?) {
        let controller = AKILocationViewController()
        controller.userModel = userModel
        self.pushViewController(controller)
    }
    
    private func fill(userModel: AKIUser) -> AKIUser {
        var userModel = userModel
        let rootView = self.rootView
        
        userModel.password = rootView?.passwordTextField?.text ?? ""
        userModel.email = rootView?.emailTextField?.text ?? ""
        
        return userModel
    }
    
    private func prepareView() {
        let tap  = self.tap
        tap.addTarget(self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.loginFirebaseButton()
        self.signUpButton()
        self.loginFacebookButton()
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

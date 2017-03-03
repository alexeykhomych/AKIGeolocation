//
//  AKILoginView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class AKILoginView: UIView {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var loginWithFBButton: UIButton?
    @IBOutlet var signUpButton: UIButton?
    
    let disposeBag = DisposeBag()
    
    func addBindsToViewModel(_ viewModel: AKIViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        guard let emailTextField = self.emailTextField else {
            return
        }
        
        guard let passwordTextField = self.emailTextField else {
            return
        }
        
        guard let userEmail = viewModel.email else {
            return
        }
        
        guard let userPassword = viewModel.password else {
            return
        }
        
        guard let loginButton = self.loginButton else {
            return
        }
        
        let emailValidate: Observable<Bool> = emailTextField.rx.text.map({ text -> Bool in
            viewModel.emailValidation(emailTextField.text)
//            emailTextField.text.map { viewModel.emailValidation($0) }
        }).shareReplay(1)
        
//        let emailValidate: Observable<Bool> = emailTextField?.text.map { viewModel.emailValidation($0) }
        
        let passwordValidate: Observable<Bool> = passwordTextField.rx.text.map({ text -> Bool in
            viewModel.passwordValidation(passwordTextField.text)
        }).shareReplay(1)
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(emailValidate, passwordValidate) { $0 && $1 }
        
        everythingValid.bindTo(loginButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
        let mail = emailTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = mail.bindTo(userEmail)
        
        let password = passwordTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = password.bindTo(userPassword)
    }
}

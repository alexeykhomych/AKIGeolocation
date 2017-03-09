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
    
    func addBindsToViewModel(_ userModel: AKIUser) {
        
        guard let emailTextField = self.emailTextField else {
            return
        }
        
        guard let passwordTextField = self.passwordTextField else {
            return
        }
        
        guard let loginButton = self.loginButton else {
            return
        }
        
        guard let userEmail = userModel.email else {
            return
        }
        
        guard let userPassword = userModel.password else {
            return
        }

        let emailValidate: Observable<Bool> = emailTextField.rx.text.map({ text -> Bool in
            userModel.emailValidation(text)
        }).shareReplay(1)
        
        let passwordValidate: Observable<Bool> = passwordTextField.rx.text.map({ text -> Bool in
            userModel.passwordValidation(text)
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

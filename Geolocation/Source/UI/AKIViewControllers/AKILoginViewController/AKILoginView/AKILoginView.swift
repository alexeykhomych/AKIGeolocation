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
    
    func addBinds(to userModel: AKIUser) {
        
        guard let emailTextField = self.emailTextField,
            let passwordTextField = self.passwordTextField else
        {
            return
        }
    
        let userEmail = self.unwrap(value: userModel.email, defaultValue: Variable<String>(""))
        let userPassword = self.unwrap(value: userModel.password, defaultValue: Variable<String>(""))
        
        let emailValidate: Observable<Bool> = emailTextField.rx.text.map {
            userModel.passwordValidation($0)
        }
        
        let passwordValidate: Observable<Bool> = passwordTextField.rx.text.map {
            userModel.passwordValidation($0)
        }
        
        _ = Observable.combineLatest(emailValidate, passwordValidate) { $0 && $1 }
            .bindTo(self.loginButton!.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
        _ = emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bindTo(userEmail)
        
        _ = passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bindTo(userPassword)
    }
}

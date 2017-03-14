//
//  AKISignUpView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class AKISignUpView: UIView {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    @IBOutlet var signUpButton: UIButton?
        
    let disposeBag = DisposeBag()
    
    func addBinds(to userModel: AKIUser?) { 
        guard let userModel = userModel,
            let emailTextField = self.emailTextField,
            let passwordTextField = self.passwordTextField,
            let nameTextField = self.nameTextField,
            let signUpButton = self.signUpButton else
        {
            return
        }
        
        let userEmail = self.unwrap(value: userModel.email, defaultValue: Variable<String>(""))
        let userName = self.unwrap(value: userModel.name, defaultValue: Variable<String>(""))
        let userPassword = self.unwrap(value: userModel.password, defaultValue: Variable<String>(""))
        
        let emailValidate: Observable<Bool> = passwordTextField.rx.text.map {
            userModel.emailValidation($0)
        }
        
        let passwordValidate: Observable<Bool> = passwordTextField.rx.text.map {
            userModel.passwordValidation($0)
        }
        
        let nameValidate: Observable<Bool> = nameTextField.rx.text.map {
            userModel.nameValidation($0)
        }
        
        _ = Observable.combineLatest(emailValidate, passwordValidate, nameValidate) { $0 && $1 && $2 }
            .bindTo(signUpButton.rx.isEnabled)
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
        
        _ = nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bindTo(userName)
    }
}

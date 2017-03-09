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
    
    func addBindsToViewModel(_ userModel: AKIUser?) {
        guard let userModel = userModel else {
            return
        }
        
        guard let emailTextField = self.emailTextField else {
            return
        }
        
        guard let passwordTextField = self.passwordTextField else {
            return
        }
        
        guard let nameTextField = self.nameTextField else {
            return
        }
        
        guard let signUpButton = self.signUpButton else {
            return
        }
        
        guard let userEmail = userModel.email else {
            return
        }
        
        guard let userPassword = userModel.password else {
            return
        }
        
        guard let userName = userModel.name else {
            return
        }
        
        let emailValidate: Observable<Bool> = emailTextField.rx.text.map({ text -> Bool in
            userModel.emailValidation(text)
        }).shareReplay(1)
        
        let passwordValidate: Observable<Bool> = passwordTextField.rx.text.map({ text -> Bool in
            userModel.passwordValidation(text)
        }).shareReplay(1)
        
        let nameValidate: Observable<Bool> = nameTextField.rx.text.map({ text -> Bool in
            userModel.nameValidation(text)
        }).shareReplay(1)
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(emailValidate, passwordValidate, nameValidate) { $0 && $1 && $2 }
        
        everythingValid.bindTo(signUpButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
        let mail = emailTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = mail.bindTo(userEmail)
        
        let password = passwordTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = password.bindTo(userPassword)
        
        let name = nameTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = name.bindTo(userName)
    }
}

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
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
        
    let disposeBag = DisposeBag()
    
    func addBindsToViewModel(_ viewModel: AKIViewModel) {
        let emailValidate: Observable<Bool> = self.emailTextField!.rx.text.map({ text -> Bool in
            viewModel.emailValidation(self.emailTextField.text!)
        }).shareReplay(1)
        
        let passwordValidate: Observable<Bool> = self.passwordTextField!.rx.text.map({ text -> Bool in
            viewModel.passwordValidation(self.passwordTextField.text!)
        }).shareReplay(1)
        
        let nameValidate: Observable<Bool> = self.nameTextField!.rx.text.map({ text -> Bool in
            viewModel.nameValidation(self.nameTextField.text!)
        }).shareReplay(1)
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(emailValidate, passwordValidate, nameValidate) { $0 && $1 && $2 }
        
        everythingValid.bindTo(self.signUpButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
        let mail = self.emailTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = mail.bindTo(viewModel.email!)
        
        let password = self.passwordTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = password.bindTo(viewModel.password!)
        
        let name = self.nameTextField.rx.text.orEmpty.distinctUntilChanged().observeOn(MainScheduler.instance)
        _ = name.bindTo(viewModel.name!)
    }

}

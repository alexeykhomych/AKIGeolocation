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
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loginWithFBButton: UIButton?
    @IBOutlet var signUpButton: UIButton?
    
    @IBOutlet var passwordValidLable: UILabel!
    @IBOutlet var emailValidLable: UILabel!
    
    let disposeBag = DisposeBag()
    
    func addBindsToViewModel(_ viewModel: AKIViewModel) {
        
        let email: Observable<Bool> = self.emailTextField!.rx.text.map({ text -> Bool in
            viewModel.emailValidation(self.emailTextField.text!)
        }).shareReplay(1)
        
        let password: Observable<Bool> = self.passwordTextField!.rx.text.map({ text -> Bool in
            viewModel.passwordValidation(self.passwordTextField.text!)
        }).shareReplay(1)
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(email, password) { $0 && $1 }
        
        everythingValid.bindTo(self.loginButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
        
//        viewModel.password.bindTo(self.passwordTextField?.rx.text)
//            .addDisposableTo(self.disposeBag)
//        
//        viewModel.email?.bindTo(self.emailTextField?.rx.text.flatMap{ text in return text })
//            .addDisposableTo(self.disposeBag)
    }
}

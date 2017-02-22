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
    
    func addBindsToViewModel(_ loginViewModel: AKILoginViewModel) {
        loginViewModel.email
            .asObservable()
            .map({ text -> String? in
                return Optional(text)
            })
            .bindTo(self.emailTextField.rx.text)
            .addDisposableTo(self.disposeBag)
        
        loginViewModel.password
            .bindTo(self.passwordTextField.rx.text)
            .addDisposableTo(self.disposeBag)
    }
}

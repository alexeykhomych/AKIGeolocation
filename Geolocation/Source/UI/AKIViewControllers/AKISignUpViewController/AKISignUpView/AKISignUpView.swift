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

class AKISignUpView: UIView, AKIValidateStringWithPredicate {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var passwordValidLable: UILabel!
    @IBOutlet var emailValidLable: UILabel!
    @IBOutlet var nameValidLable: UILabel!
    
    let disposeBag = DisposeBag()
    
    func validateFields() {
        let email: Observable<Bool> = self.emailTextField!.rx.text.map({ text -> Bool in
            self.AKIValidateStringWithPredicate(text!, predicate: NSPredicate(format: kAKIPredicateEmailFormat,
                                                                            kAKIPredicateEmailRegex))
        }).shareReplay(1)
        
        let password: Observable<Bool> = self.passwordTextField!.rx.text.map({ text -> Bool in
            self.AKIValidateStringWithPredicate(text!, predicate: NSPredicate(format: kAKIPredicatePasswordFormat,
                                                                          text!.characters.count,
                                                                          kAKIPredicateMinimalPasswordLength))
        }).shareReplay(1)
        
        let name: Observable<Bool> = self.nameTextField!.rx.text.map({ text -> Bool in
            self.AKIValidateStringWithPredicate(text!, predicate: NSPredicate(format: kAKIPredicatePasswordFormat,
                                                                           text!.characters.count,
                                                                           kAKIPredicateMinimalPasswordLength))
        }).shareReplay(1)
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(email, password, name) { $0 && $1 && $2 }
        
        email.bindTo(self.emailValidLable.rx.isHidden)
            .addDisposableTo(self.disposeBag)
        
        password.bindTo(self.passwordValidLable.rx.isHidden)
            .addDisposableTo(self.disposeBag)
        
        name.bindTo(self.nameValidLable.rx.isHidden)
            .addDisposableTo(self.disposeBag)
        
        everythingValid.bindTo(self.signUpButton.rx.isEnabled)
            .addDisposableTo(self.disposeBag)
    }
}

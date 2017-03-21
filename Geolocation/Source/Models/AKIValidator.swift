//
//  AKIValidator.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/21/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AKIValidator {
    
    private let disposeBag = DisposeBag()
    
    func nameValidation(_ name: String) -> Bool {
        return name.characters.count > 0 && self.validateStringWithPredicate(NSPredicate(format: Validation.nameFormat,
                                                                                          Validation.nameRegex))
    }
    
    func passwordValidation(_ password: String) -> Bool {
        return password.characters.count > 0 && self.validateStringWithPredicate(NSPredicate(format: Validation.passwordFormat,
                                                                                              password.characters.count,
                                                                                              Validation.minimalPasswordLength))
    }
    
    func emailValidation(_ email: String) -> Bool {
        return email.characters.count > 0 && self.validateStringWithPredicate(NSPredicate(format: Validation.emailFormat,
                                                                                          Validation.emailRegex))
    }
    
    func validateStringWithPredicate(_ predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: self)
    }
    
//    var bindsArray: Array<Variable<Any>>?
//    var bindsArray: Dictionary<UITextField, Variable<String>>?
    var bindsArray: Dictionary<UITextField, UILabel>?
    
    func setBind(with textField: UITextField, label: UILabel) {
        let bind: Observable<Bool> = textField.rx.text.map { text -> Bool in
            self.emailValidation(text!)
        }
        
        bind.bindTo(label.rx.isHidden)
            .addDisposableTo(self.disposeBag)
    }
}

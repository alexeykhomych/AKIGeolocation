//
//  AKITextValidation.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/20/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

protocol AKIValidateStringWithPredicate {
    func AKIValidateStringWithPredicate(_ string: String, predicate: NSPredicate) -> Bool
}

extension AKIValidateStringWithPredicate {
    func AKIValidateStringWithPredicate(_ string: String, predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: string)
    }
}

struct AKITextValidation {
    private var passwordValidation = AKIPasswordValidation()
    private var emailValidation = AKIEmailValidation()
    private var nameValidation = AKINameValidation()
    
    func checkEmail(email: String) -> Bool {
        return self.emailValidation.emailValidation(email)
    }
    
    func checkPassword(password: String) -> Bool {
        return self.passwordValidation.passwordValidation(password)
    }
    
    func checkName(name: String) -> Bool {
        return self.nameValidation.nameValidation(name)
    }
}

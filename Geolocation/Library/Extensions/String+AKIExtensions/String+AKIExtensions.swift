//
//  String+AKIExtensions.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/22/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import Foundation

extension String {
    
    func passwordValidation(_ password: String) -> Bool {
        return self.validateStringWithPredicate(password, predicate: NSPredicate(format: kAKIPredicatePasswordFormat,
                                                                                    password.characters.count,
                                                                                    kAKIPredicateMinimalPasswordLength))
    }
    
    func nameValidation(_ name: String) -> Bool {
        return self.validateStringWithPredicate(name, predicate: NSPredicate(format: kAKIPredicateNameRegex,
                                                                                name.characters.count,
                                                                                kAKIPredicateMinimalPasswordLength))
    }
    
    func emailValidation(_ email: String) -> Bool {
        return self.validateStringWithPredicate(email, predicate: NSPredicate(format: kAKIPredicateEmailFormat,
                                                                                 kAKIPredicateEmailRegex))
    }

    func validateStringWithPredicate(_ string: String, predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: string)
    }
    
}

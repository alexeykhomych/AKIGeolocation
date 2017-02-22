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
        return self.validateStringWithPredicate(password, predicate: NSPredicate(format: Validation.passwordFormat,
                                                                                    password.characters.count,
                                                                                    Validation.minimalPasswordLength))
    }
    
    func nameValidation(_ name: String) -> Bool {
        return self.validateStringWithPredicate(name, predicate: NSPredicate(format: Validation.nameRegex,
                                                                                name.characters.count,
                                                                                Validation.minimalNameLength))
    }
    
    func emailValidation(_ email: String) -> Bool {
        return self.validateStringWithPredicate(email, predicate: NSPredicate(format: Validation.emailFormat,
                                                                                 Validation.emailRegex))
    }

    func validateStringWithPredicate(_ string: String, predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: string)
    }
    
}

//
//  String+AKIExtensions.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/22/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import Foundation

extension String {
    
    func passwordValidation() -> Bool {
        return self.validateStringWithPredicate(NSPredicate(format: Validation.passwordFormat,
                                                            self.characters.count,
                                                            Validation.minimalPasswordLength))
    }
    
    func nameValidation() -> Bool {
        return self.validateStringWithPredicate(NSPredicate(format: Validation.nameRegex,
                                                            self.characters.count,
                                                            Validation.minimalNameLength))
    }
    
    func emailValidation() -> Bool {
        return self.validateStringWithPredicate(NSPredicate(format: Validation.emailFormat,
                                                            Validation.emailRegex))
    }

    func validateStringWithPredicate(_ predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: self)
    }
    
}

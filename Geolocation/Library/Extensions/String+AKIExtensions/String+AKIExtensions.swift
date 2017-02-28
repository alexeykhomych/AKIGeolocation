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
        return self.characters.count > 0 && self.validateStringWithPredicate(NSPredicate(format: Validation.passwordFormat,
                                                            self.characters.count,
                                                            Validation.minimalPasswordLength))
    }
    
    func nameValidation() -> Bool {
        return self.characters.count > 0 && self.validateStringWithPredicate(NSPredicate(format: Validation.nameFormat,
                                                            Validation.nameRegex))
    }
    
    func emailValidation() -> Bool {
        return self.characters.count > 0 && self.validateStringWithPredicate(NSPredicate(format: Validation.emailFormat,
                                                            Validation.emailRegex))
    }

    func validateStringWithPredicate(_ predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: self)
    }
    
    func unwrappedString(_ optionalString: String?) -> String {
        return optionalString ?? ""
    }    
}

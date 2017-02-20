//
//  AKIPasswordValidation.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/20/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKIPasswordValidation: AKIValidateStringWithPredicate {
    func passwordValidation(_ password: String) -> Bool {
        return self.AKIValidateStringWithPredicate(password, predicate: NSPredicate(format: kAKIPredicatePasswordFormat,
                                                                                 password.characters.count,
                                                                                 kAKIPredicateMinimalPasswordLength))
    }
}

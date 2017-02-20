//
//  AKIEmailValidation.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/20/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKIEmailValidation: AKIValidateStringWithPredicate {
    func emailValidation(_ email: String) -> Bool {
        return self.AKIValidateStringWithPredicate(email, predicate: NSPredicate(format: kAKIPredicateEmailFormat,
                                                                              kAKIPredicateEmailRegex))
    }
}

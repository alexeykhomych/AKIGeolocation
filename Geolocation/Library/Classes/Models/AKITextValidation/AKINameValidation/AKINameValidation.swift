//
//  AKINameValidation.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/20/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKINameValidation: AKIValidateStringWithPredicate {
    func nameValidation(_ name: String) -> Bool {
        return self.AKIValidateStringWithPredicate(name, predicate: NSPredicate(format: kAKIPredicateNameRegex,
                                                                             name.characters.count,
                                                                             kAKIPredicateMinimalPasswordLength))
    }
}

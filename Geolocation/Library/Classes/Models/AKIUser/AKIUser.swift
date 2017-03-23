//
//  AKIUser.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

extension AKIUser {
    
    func nameValidation() -> Bool {
        return self.name.nameValidation()
    }
    
    func passwordValidation() -> Bool {
        return self.password.passwordValidation()
    }
    
    func emailValidation() -> Bool {
        return self.email.emailValidation()
    }
}

struct AKIUser {
    
    var email: String
    var password: String
    var name: String
    var id: String

    init() {
        self.email = ""
        self.password = ""
        self.name = ""
        self.id = ""
    }
}

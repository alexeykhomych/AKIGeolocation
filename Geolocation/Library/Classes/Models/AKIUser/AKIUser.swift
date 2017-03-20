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
    
    func nameValidation(_ name: String?) -> Bool {
        return name?.nameValidation() ?? false
    }
    
    func passwordValidation(_ password: String?) -> Bool {
        return password?.passwordValidation() ?? false
    }
    
    func emailValidation(_ email: String?) -> Bool {
        return email?.emailValidation() ?? false
    }
}

struct AKIUser {
    
    let email: String
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

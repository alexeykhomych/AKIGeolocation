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

extension AKIUserViewModelProtocol {
    
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

protocol AKIUserViewModelProtocol {
    
    func nameValidation(_ name: String?) -> Bool
    func passwordValidation(_ password: String?) -> Bool
    func emailValidation(_ email: String?) -> Bool
    
}

struct AKIUser: AKIUserViewModelProtocol {
    
    var email: Variable<String>?
    var password: Variable<String>?
    var name: Variable<String>?
    var id: String?

    init() {
        self.email = Variable<String>("")
        self.password = Variable<String>("")
        self.name = Variable<String>("")
        self.id = ""
    }
}

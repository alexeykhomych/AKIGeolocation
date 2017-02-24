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

extension AKIUserProtocol {
    
    mutating func initWithEmptyFields() {
        self.email = ""
        self.password = ""
        self.name = ""
        self.id = ""
    }
}

protocol AKIUserProtocol {
    
    var email: String? { get set }
    var password: String? { get set }
    var name: String? { get set }
    var id: String? { get set }
    
    init(email: String, password: String, name: String)
}

class AKIUser: AKIUserProtocol {
    
    var email: String?
    var password: String?
    var name: String?
    var id: String?
    
    init() {
        self.email = ""
        self.password = ""
        self.name = ""
        self.id = ""
    }
    
    required init(email: String, password: String, name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
}

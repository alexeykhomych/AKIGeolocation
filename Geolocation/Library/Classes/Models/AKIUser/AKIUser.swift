//
//  AKIUser.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKIUser: NSObject {
    
    var email: String?
    var password: String?
    var name: String?
    var id: String?
    
    override init() {
        self.email = kAKIEmptyString
        self.password = kAKIEmptyString
        self.name = kAKIEmptyString
        self.id = kAKIEmptyString
    }
    
    init(_ email: String, password: String, name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
}

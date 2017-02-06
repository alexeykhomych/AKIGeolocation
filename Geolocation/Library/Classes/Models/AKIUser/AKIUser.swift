//
//  AKIUser.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKIUser: NSObject {
    
    var login: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    
    init(_ login: String, password: String, firstName: String, lastName: String) {
        self.login = login
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}

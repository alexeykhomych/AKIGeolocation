//
//  AKIConstants.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/3/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

struct Context {
    struct Request {
        static let fireBaseURL = "https://test-ec520.firebaseio.com/"
        static let facebookMe = "/me"
        static let fields = "fields"
        static let id = "id"
        static let name = "name"
        static let email = "email"
        static let users = "users"
        static let coordinates = "coordinates"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let password = "password"        
    }
    
    struct Field {
        
    }
    
    struct Permission {
        static let publicProfile = "public_profile"
        static let email = "email"
    }
    
    struct Key {
        static let googleAPI = "AIzaSyDhCTlo2o_D_SDwFUWdtf8C1t_2i-ksHdA"
    }
}

struct Validation {
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let emailFormat = "SELF MATCHES %@"
    static let passwordFormat = "%d >= %d"
    static let nameRegex = "\\A\\w{5,18}\\z"
    static let minimalPasswordLength = 6
    static let minimalNameLength = 6
}

struct Google {
    struct Maps {
        struct Default {
            static let zoom: Float = 15.0
            static let distanceFilter = 50
        }
    }
    
    struct API {
        static let key = "AIzaSyDhCTlo2o_D_SDwFUWdtf8C1t_2i-ksHdA"
    }
}

struct Timer {
    struct Default {
        static let timerInterval = 60
        static let debounceOneSecond = 1.0
    }
}

struct UI {
    struct AllertMessage {
        static let titleOk = "Ok"
        static let titleError = "Error"
    }
}

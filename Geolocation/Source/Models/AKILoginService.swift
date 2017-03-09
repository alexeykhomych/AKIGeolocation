//
//  AKILoginService.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import FBSDKLoginKit

enum LoginServiceType {
    case Facebook
    case Firebase
}

class AKILoginService {
    
    var userModel: AKIUser?
    
    init(_ userModel: AKIUser?) {
        self.userModel = userModel
    }
    
    func login(_ service: LoginServiceType) -> Observable<AKIUser> {
        switch service {
            case .Facebook:
                return AKIFacebookLoginProvider(self.userModel!).login()
            case .Firebase:
                return AKIFirebaseLoginProvider(self.userModel!).login()
        }
    }
    
    func loginWithFacebookAccessToken() -> Observable<AKIUser> {
        return AKIFacebookLoginProvider(self.userModel!).loginWithAccessToken()
    }
    
    func logout(_ service: LoginServiceType) -> Observable<AKIUser> {
        switch service {
        case .Facebook:
            return AKIFacebookLoginProvider(self.userModel!).logout()
        case .Firebase:
            return AKIFirebaseLoginProvider(self.userModel!).logout()
        }
    }
    
    func signup() -> Observable<AKIUser> {
        return AKIFirebaseLoginProvider(self.userModel!).signup()
    }
}

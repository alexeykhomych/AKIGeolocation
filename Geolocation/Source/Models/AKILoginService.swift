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
        guard let userModel = self.userModel else {
            return Observable<AKIUser>.empty()
        }
        
        switch service {
            case .Facebook:
                return AKIFacebookLoginProvider(userModel).login()
            case .Firebase:
                return AKIFirebaseLoginProvider(userModel).login()
        }
    }
    
    func loginWithFacebookAccessToken() -> Observable<AKIUser> {
        guard let userModel = self.userModel else {
            return Observable<AKIUser>.empty()
        }
        
        return AKIFacebookLoginProvider(userModel).loginWithAccessToken()
    }
    
    func logout(_ service: LoginServiceType) -> Observable<AKIUser> {
        guard let userModel = self.userModel else {
            return Observable<AKIUser>.empty()
        }
        
        switch service {
        case .Facebook:
            return AKIFacebookLoginProvider(userModel).logout()
        case .Firebase:
            return AKIFirebaseLoginProvider(userModel).logout()
        }
    }
    
    func signup() -> Observable<AKIUser> {
        guard let userModel = self.userModel else {
            return Observable<AKIUser>.empty()
        }
        
        return AKIFirebaseLoginProvider(userModel).signup()
    }
}

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
    case FacebookToken
    case FirebaseToken
}

class AKILoginService {
    
    func login(with userModel: AKIUser, service: LoginServiceType) -> Observable<AKIUser> {
        switch service {
            case .Facebook:
                return AKIFacebookLoginProvider().login(with: userModel)
            case .Firebase:
                return AKIFirebaseLoginProvider().login(with: userModel)
            case .FacebookToken:
                return AKIFacebookLoginProvider().loginWithAccessToken(with: userModel)
            case .FirebaseToken:
                return AKIFirebaseLoginProvider().loginWithAccessToken(with: userModel)
        }
    }
    
    func logout(with userModel: AKIUser, service: LoginServiceType) -> Observable<AKIUser> {
        switch service {
            case .Facebook:
                return AKIFacebookLoginProvider().logout(with: userModel)
            case .Firebase:
                return AKIFirebaseLoginProvider().logout(with: userModel)
            default:
                return Observable<AKIUser>.empty()
        }
    }
    
    func signup(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseLoginProvider().signup(with: userModel)
    }
}

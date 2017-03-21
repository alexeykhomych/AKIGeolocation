//
//  AKIFacebookLoginProvider.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import RxSwift
import RxCocoa

protocol AKIFacebookLoginProtocol {
    func loginWithAccessToken() -> Observable<AKIUser>
    func login() -> Observable<AKIUser>
}

class AKIFacebookLoginProvider: AKIFacebookLoginProtocol {
   
    var accessToken: FBSDKAccessToken? {
        return FBSDKAccessToken.current()
    }
    
    func loginWithAccessToken() -> Observable<AKIUser> {
        if FBSDKAccessToken.current() == nil {
            return Observable<AKIUser>.empty()
        }
        
        return self.login()
    }
    
    func login() -> Observable<AKIUser> {
        return AKIFacebookLoginContext().execute()
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFacebookLogoutContext().execute()
    }
}



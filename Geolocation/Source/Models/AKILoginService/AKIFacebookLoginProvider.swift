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
    
    var userModel: AKIUser?
        
    let disposeBag = DisposeBag()
    
    init(_ userModel: AKIUser) {
        self.userModel = userModel
    }
   
    func loginWithAccessToken() -> Observable<AKIUser> {
        return (FBSDKAccessToken.current() != nil) ? self.login() : Observable<AKIUser>.empty()
    }
    
    func login() -> Observable<AKIUser> {
        return AKIFacebookLoginContext(self.userModel).execute()
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFacebookLogoutContext(self.userModel).execute()
    }
}



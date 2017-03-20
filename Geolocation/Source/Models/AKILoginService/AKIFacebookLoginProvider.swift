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
    func loginWithAccessToken(with userModel: AKIUser) -> Observable<AKIUser>
    func login(with userModel: AKIUser) -> Observable<AKIUser>
}

class AKIFacebookLoginProvider: AKIFacebookLoginProtocol {
   
    func loginWithAccessToken(with userModel: AKIUser) -> Observable<AKIUser> {
        guard let user = FBSDKAccessToken.current() else {
            return Observable<AKIUser>.empty()
        }
        
        var userModel = userModel
        userModel.id = user.userID
        
        return self.login(with: userModel)
    }
    
    func login(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFacebookLoginContext().execute()
    }
    
    func logout(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFacebookLogoutContext().execute()
    }
}



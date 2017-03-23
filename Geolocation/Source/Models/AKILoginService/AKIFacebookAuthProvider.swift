//
//  AKIFacebookAuthProvider.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import RxSwift
import RxCocoa

class AKIFacebookAuthProvider {
    
    var credential:FBSDKAccessToken? {
        return FBSDKAccessToken.current()
    }
    
    func login(viewController: UIViewController) -> Observable<FBSDKAccessToken> {
        if FBSDKAccessToken.current() != nil {
            return AKIFacebookLoginContext().loginWithToken()
        }
        
        return AKIFacebookLoginContext().execute(viewController: viewController)
    }
    
    func logout() -> Observable<Bool> {
        return AKIFacebookLogoutContext().execute()
    }
}

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

protocol AKIFacebookAuthProtocol {
    func login(viewController: UIViewController) -> Observable<FBSDKLoginManagerLoginResult>
}

class AKIFacebookAuthProvider: AKIFacebookAuthProtocol {
    
    func login(viewController: UIViewController) -> Observable<FBSDKLoginManagerLoginResult> {
        if FBSDKAccessToken.current() != nil {
            return AKIFacebookLoginContext().loginWithToken()
        }
        
        return AKIFacebookLoginContext().execute(viewController: viewController)
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFacebookLogoutContext().execute()
    }
}

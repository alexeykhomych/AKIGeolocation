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

protocol AKIFacebookLoginProtocol {
    func loginWithAccessToken() -> ((Void) -> ())
    func login(context: AKIFacebookLoginContext)
}

extension AKIFacebookLoginProtocol where Self: UIViewController {
    func loginWithAccessToken() -> ((Void) -> ()) {
        let accessToken = FBSDKAccessToken.current()
        
        var model = AKIUser()
        
        if accessToken != nil {
            model.id = accessToken?.userID
            
            return {
                let controller = AKILocationViewController()
                controller.model = model
                self.pushViewController(controller)
            }
        }
        
        return {
            
        }
    }
}

protocol AKIFirebaseLoginProtocol {
    
    func login(context: AKILoginContext)
    
}

class AKILoginService: AKIFacebookLoginProtocol, AKIFirebaseLoginProtocol {
    
    internal func login(context: AKILoginContext) {
        
    }

    
    internal func login(context: AKIFacebookLoginContext) {
        
    }

    internal func loginWithAccessToken() -> ((Void) -> ()) {
        return {
            
        }
    }

}

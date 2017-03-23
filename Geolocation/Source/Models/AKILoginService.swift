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
    case Email
}

class AKILoginService {
    
    // MARK: Accessors
    
    private var facebookLoginProvider = AKIFacebookAuthProvider()
    private var firebaseLoginProvider = AKIFirebaseAuthProvider()
    
    // MARK: Public methods
    
    func login(with userModel: AKIUser, service: LoginServiceType) -> Observable<AKIUser> {
        return self.login(with: userModel, service: service, viewController: nil)
    }
    
    func login(with userModel: AKIUser, service: LoginServiceType, viewController: UIViewController?) -> Observable<AKIUser> {
        switch service {
            case .Facebook:
                guard let viewController = viewController else {
                    print("viewController is nil in AKILoginService")
                    return Observable<AKIUser>.empty()
                }
                
                return self.facebookLoginProvider.login(viewController: viewController).flatMap {
                    return self.firebaseLoginProvider.login(credential: $0.token)
                }
            case .Email:
                return self.firebaseLoginProvider.login(with: userModel)
        }
    }
    
    func logout() -> Observable<AKIUser> {
        return self.facebookLoginProvider.logout().flatMap { _ in
            return self.firebaseLoginProvider.logout()
        }
    }
    
    func signup(with userModel: AKIUser) -> Observable<AKIUser> {
        return self.firebaseLoginProvider.signup(with: userModel)
    }
}

//
//  AKIAuthService.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import FBSDKLoginKit
import Firebase
import FirebaseAuth

protocol AKIAuthProviderProtocol {
    associatedtype Value
//    func login(viewController: UIViewController) -> Observable<Value>
}

enum LoginServiceType {
    case facebook
    case email
    case token
}

class AKIAuthService {
    
    // MARK: Accessors
    
    private var facebookLoginProvider = AKIFacebookAuthProvider()
    private var firebaseLoginProvider = AKIFirebaseAuthProvider()
    
    // MARK: Public methods
    
    func login(with userModel: AKIUser, service: LoginServiceType, viewController: UIViewController) -> Observable<AKIUser> {
        switch service {
            case .facebook:
                return self.facebookLoginProvider.login(viewController: viewController).flatMap {
                    return self.firebaseLoginProvider.login(credential: $0)
                }
            case .email:
                return self.firebaseLoginProvider.login(with: userModel)
            case .token:
                if firebaseLoginProvider.currentUser == nil {
                    print("FIR user is nil")
                    return Observable<AKIUser>.empty()
                }
                return self.firebaseLoginProvider.login(credential: facebookLoginProvider.credential!)
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

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
}

class AKIAuthService {
    
    // MARK: Accessors
    
    private var facebookLoginProvider = AKIFacebookAuthProvider()
    private var firebaseLoginProvider = AKIFirebaseAuthProvider()
    
    // MARK: Public methods
    
    func login(with userModel: AKIUser, service: LoginServiceType, viewController: UIViewController) -> Observable<FIRUser> {
        switch service {
            case .facebook:
                return self.facebookLoginProvider.login(viewController: viewController).flatMap { _ in
//                    return self.firebaseLoginProvider.login(userModel: $0)
                    return self.firebaseLoginProvider.login(userModel: userModel)
                }
            case .email:
                return self.firebaseLoginProvider.login(userModel: userModel)
        }
    }
    
    func logout() -> Observable<Bool> {
        return self.firebaseLoginProvider.logout()
//        return self.facebookLoginProvider.logout().flatMap { _ in
//            return self.firebaseLoginProvider.logout()
//        }
    }
    
    func signup(with userModel: AKIUser) -> Observable<FIRUser> {
        return self.firebaseLoginProvider.signup(userModel: userModel)
    }
}

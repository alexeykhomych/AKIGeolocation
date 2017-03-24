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

extension FIRUser {
    func fill(userModel: AKIUser) -> AKIUser {
        var userModel = userModel
        userModel.email = self.email ?? ""
        userModel.id = self.uid
        
        return userModel
    }
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
                    self.firebaseLoginProvider.login(userModel: userModel, token: $0.tokenString).map {
                        $0.fill(userModel: userModel)
                    }}
            case .email:
                return self.firebaseLoginProvider.login(userModel: userModel, token: nil).map {
                    $0.fill(userModel: userModel)
                }
        }
    }
    
    func logout() -> Observable<Bool> {
        return self.firebaseLoginProvider.logout()
    }
    
    func signup(with userModel: AKIUser) -> Observable<AKIUser> {
        return self.firebaseLoginProvider.signup(userModel: userModel).map {
            $0.fill(userModel: userModel)
        }
    }
}

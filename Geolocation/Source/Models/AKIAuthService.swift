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

import Result

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

extension Result {
//    func returnResult(model: AKIUser) -> Result<AKIUser, AuthError> {
//        switch self {
//        case let .success(user):
//            return .success((user as? FIRUser)!.fill(userModel: model))
//        case let .failure(error):
//            return .failure(error)
        
            //                        $0.fill(userModel: userModel)
//        }
//    }
}

class AKIAuthService {
    
    // MARK: Accessors
    
    private var facebookLoginProvider = AKIFacebookAuthProvider()
    private var firebaseLoginProvider = AKIFirebaseAuthProvider()
    
    // MARK: Public methods
    
    func login(with userModel: AKIUser, service: LoginServiceType, viewController: UIViewController) -> Observable<Result<AKIUser, AuthError>> {
        switch service {
            case .facebook:
                return self.facebookLoginProvider.login(viewController: viewController).flatMap {
                    self.firebaseLoginProvider.login(userModel: userModel, token: $0.tokenString).map { result in
                        switch result {
                        case let .success(user):
                            return .success(user.fill(userModel: userModel))
                        case .failure(.failedConnection):
                            return .failure(.failedConnection)
                        default:
                            return .failure(.failedConnection)
                        }
                        }
                    }
            case .email:
                return self.firebaseLoginProvider.login(userModel: userModel, token: nil).map { result in
                    switch result {
                    case let .success(user):
                        return .success(user.fill(userModel: userModel))
                    case .failure(.failedConnection):
                        return .failure(.failedConnection)
                    default:
                        return .failure(.failedConnection)
                    }
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

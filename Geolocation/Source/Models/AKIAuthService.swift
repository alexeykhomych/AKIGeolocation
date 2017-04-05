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

enum AuthError: Error {
    case description(String)
    case emptyUser
}

extension AKIUser {
    func fill(user: FIRUser) -> AKIUser {
        var userModel = self
        userModel.email = user.email ?? ""
        userModel.id = user.uid
        
        return userModel
    }
}

extension Result {
    func fill(model: AKIUser) -> Result<AKIUser, AuthError> {
        switch self {
        case let .success(user):
            return .success(model.fill(user: user as! FIRUser))
        default:
            return .failure(AuthError.emptyUser)
        }
    }
}

class AKIAuthService {
    
    typealias Signal = Observable<Result<AKIUser, AuthError>>
    
    static let instance = AKIAuthService()
    
    // MARK: - Accessors
    
    private var facebookLoginProvider = AKIFacebookAuthProvider()
    private var firebaseLoginProvider = AKIFirebaseAuthProvider()
    
    // MARK: - Public methods
    
    func login(with userModel: AKIUser, service: LoginServiceType, viewController: UIViewController) -> Signal {
        switch service {
            case .facebook:
                return self.facebookLoginProvider.login(viewController: viewController).flatMap {
                    self.firebaseLoginProvider.login(userModel: userModel, token: $0.tokenString).map {
                        $0.fill(model: userModel)
                    }
                }
            case .email:
                return self.firebaseLoginProvider.login(userModel: userModel, token: nil).map {
                    $0.fill(model: userModel)
            }
        }
    }
    
    func signup(with userModel: AKIUser) -> Observable<Result<AKIUser, AuthError>> {
        return self.firebaseLoginProvider.signup(userModel: userModel).map {
            $0.fill(model: userModel)
        }
    }
}

//
//  AKIFirebaseLoginContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import RxCocoa
import RxSwift

import FBSDKLoginKit

enum LoginType {
    case email
    case token
    case none
}

class AKIFirebaseLoginContext: AKIContextProtocol {
    
    var userModel: AKIUser
    
    required init(userModel: AKIUser) {
        self.userModel = userModel
    }
    
    internal func execute() -> Observable<FIRUser> {
        return Observable.create { observer in
            
            // MARK: need to refactor
            
            if let currentUser = FIRAuth.auth()?.currentUser {
                observer.onNext(currentUser)
                return Disposables.create()
            }
        
            let type = self.typeLogin(userModel: self.userModel)
            
            if type == LoginType.token {
                guard let token = FBSDKAccessToken.current()?.tokenString else { return Disposables.create() }
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: token)
                FIRAuth.auth()?.signIn(with: credential, completion: self.userCompletionHandler(observer))
            }
            
            if type == LoginType.email {
                let model = self.userModel
                FIRAuth.auth()?.signIn(withEmail: model.email, password: model.password, completion: self.userCompletionHandler(observer))
            }
            
            return Disposables.create()
        }
    }
    
    private func userCompletionHandler(_ observer: AnyObserver<FIRUser>) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            if let error = error {
                observer.onError(error)
                return
            }
            
            guard let user = user else { return observer.onError(RxError.unknown) }
            
            observer.onNext(user)
            observer.onCompleted()
        }
    }
    
    private func typeLogin(userModel: AKIUser) -> LoginType {
        let empty = userModel.email.isEmpty && userModel.password.isEmpty
        
        switch empty {
        case true == (FBSDKAccessToken.current() != nil && FIRAuth.auth()?.currentUser == nil):
            return .token
        case false:
            return .email
        default:
            return .none
        }
    }
}

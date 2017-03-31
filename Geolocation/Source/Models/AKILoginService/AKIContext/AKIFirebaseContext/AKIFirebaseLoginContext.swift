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

import Result

enum AuthError: Error {
    case failedLogin
    case failedConnection
    case noneError
}

class AKIFirebaseLoginContext {
    
    typealias ReturnType = Observable<Result<FIRUser, AuthError>>
    
    var userModel: AKIUser
    var token: String?
    
    init(userModel: AKIUser, token: String?) {
        self.userModel = userModel
        self.token = token
    }
    
    func execute() -> ReturnType {
        if let currentUser = FIRAuth.auth()?.currentUser {
            return self.login(with: currentUser)
        }
        
        if let token = self.token {
            return self.login(token: token)
        }
    
        return Observable.create { observer in
            let model = self.userModel
            FIRAuth.auth()?.signIn(withEmail: model.email, password: model.password, completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    private func login(with user: FIRUser) -> ReturnType {
        return Observable.create { observer in
            
            observer.onNext(.success(user))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private func login(token: String) -> ReturnType {
        return Observable.create { observer in
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: token)
            FIRAuth.auth()?.signIn(with: credential, completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    private func userCompletionHandler(_ observer: AnyObserver<Result<FIRUser, AuthError>>) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            if error != nil {
//                observer.onError(error)
                observer.onNext(.failure(.failedConnection))
                return
            }
            
            guard let user = user else { return observer.onNext(.failure(.failedConnection)) }
            
            observer.onNext(.success(user))
            observer.onCompleted()
        }
    }
}

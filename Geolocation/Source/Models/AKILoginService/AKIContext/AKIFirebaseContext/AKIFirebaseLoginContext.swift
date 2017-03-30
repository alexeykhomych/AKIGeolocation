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
    
    var userModel: AKIUser
    var token: String?
    
    init(userModel: AKIUser, token: String?) {
        self.userModel = userModel
        self.token = token
    }
    
    typealias ReturnType = Observable<Result<FIRUser, AuthError>>
    
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
            observer.onNext(Result<user, AuthError.noneError>)
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
}

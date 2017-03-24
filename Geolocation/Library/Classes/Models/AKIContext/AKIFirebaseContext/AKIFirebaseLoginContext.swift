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

class AKIFirebaseLoginContext {
    
    var userModel: AKIUser?
    var token: String?

    init<R>(userModel: R) {
        self.userModel = userModel as? AKIUser
    }
    
    init<R>(token: R) {
        self.token = token as? String
    }
    
    func execute() -> Observable<FIRUser> {
        if self.token != nil {
            return self.login(token: self.token!)
        }
        
        return Observable.create { observer in
            if let currentUser = FIRAuth.auth()?.currentUser {
                observer.onNext(currentUser)
                observer.onCompleted()
            } else {
                guard let model = self.userModel else {
                    observer.onError(RxError.unknown)
                    
                    // MARK: need to refactor
                    return Disposables.create()
                }
                FIRAuth.auth()?.signIn(withEmail: model.email, password: model.password, completion: self.userCompletionHandler(observer))
            }
            
            return Disposables.create()
        }
    }
    
    func login(token: String) -> Observable<FIRUser> {
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

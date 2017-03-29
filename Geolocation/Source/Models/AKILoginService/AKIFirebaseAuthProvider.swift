//
//  AKIFirebaseAuthProvider.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

import FBSDKLoginKit
    
class AKIFirebaseAuthProvider {
    
    // MARK: Public methods
    
    func login(userModel: AKIUser, token: String?) -> Observable<FIRUser> {
        return AKIFirebaseLoginContext(userModel: userModel, token: token).execute()
    }
    
    func logout() -> Observable<Bool> {
        return AKIFirebaseLogoutContext().execute()
    }
    
    func signup(userModel: AKIUser) -> Observable<FIRUser> {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
    
    func sendResetPassword(with email: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                observer.onNext(true)
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    func userChangesListener() -> Observable<(FIRAuth, FIRUser)> {
        return Observable.create { observer in
            let listener = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
                guard let user = user else {
                    observer.onError(RxError.noElements)
                    return
                }
                
                observer.onNext((auth, user))
                observer.onCompleted()
            }
            
            listener.map { FIRAuth.auth()?.removeStateDidChangeListener($0) }
            
            return Disposables.create()
        }
    }
}

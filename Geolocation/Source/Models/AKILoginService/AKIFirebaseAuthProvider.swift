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

import Result
    
class AKIFirebaseAuthProvider {
    
    typealias Signal = Observable<Result<FIRUser, AuthError>>
    
    static let instance = AKIFirebaseAuthProvider()
    
    // MARK: - Public methods
    
    func login(userModel: AKIUser, token: String?) -> Signal {
        return AKIFirebaseLoginContext(userModel: userModel, token: token).execute()
    }
    
    func logout() -> Observable<Result<Bool, AuthError>> {
        return AKIFirebaseLogoutContext().execute()
    }
    
    func signup(userModel: AKIUser) -> Signal {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
    
    func sendResetPassword(with email: String) -> Observable<Result<Bool, AuthError>> {
        return Observable.create { observer in
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { error in
                if let error = error {
                    observer.onNext(.failure(.description(error.localizedDescription)))
                    return
                }
                
                observer.onNext(.success(true))
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    func userChangesListener() -> Observable<Result<(FIRAuth, FIRUser), AuthError>> {
        return Observable.create { observer in
            let listener = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
                guard let user = user else {
                    observer.onNext(.failure(.description("Empty user")))
                    return
                }
                
                observer.onNext(.success((auth, user)))
                observer.onCompleted()
            }
            
            listener.map { FIRAuth.auth()?.removeStateDidChangeListener($0) }
            
            return Disposables.create()
        }
    }
}

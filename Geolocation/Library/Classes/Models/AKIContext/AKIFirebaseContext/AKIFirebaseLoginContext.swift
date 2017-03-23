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

class AKIFirebaseLoginContext: AKIContextProtocol {
    
    var userModel: AKIUser
    
    required init(userModel: AKIUser) {
        self.userModel = userModel
    }
    
    internal func execute() -> Observable<FIRUser> {
        return Observable.create { observer in
            
            // MARK: need to refactor
            
            let currentUser = FIRAuth.auth()?.currentUser
            
            if currentUser != nil {
                observer.onNext(currentUser!)
                return Disposables.create()
            }
            
            let token = FBSDKAccessToken.current()
            
            if token != nil {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: (token?.tokenString)!)
                FIRAuth.auth()?.signIn(with: credential, completion: self.userCompletionHandler(observer))
            } else {
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
            
            observer.onNext(user!)
            observer.onCompleted()
        }
    }
}

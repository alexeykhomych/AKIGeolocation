//
//  AKIFirebaseSignUpContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import RxSwift
import RxCocoa

class AKIFirebaseSignUpContext: AKIContextProtocol{
    
    var userModel: AKIUser
    
    required init(_ userModel: AKIUser) {
        self.userModel = userModel
    }
    
    internal func execute() -> Observable<FIRUser> {
        return Observable.create { observer in
            let user = self.userModel
            FIRAuth.auth()?.createUser(withEmail: user.email,
                                       password: user.password,
                                       completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    func userCompletionHandler(_ observer: AnyObserver<FIRUser>?) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            
            if let error = error {
                observer?.onError(error)
            }
            
            let userModel = self.userModel
            // MARK: need to refactor

            let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
            let userReference = reference.child(Context.Request.users).child(Context.Request.users)
            
            let values = [Context.Request.name: userModel.name,
                          Context.Request.email: userModel.email,
                          Context.Request.password: userModel.password]
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let error = error {
                    observer?.onError(error)
                    return
                } else {
                    guard let user = user else { return }
                    observer?.onNext(user)
                    observer?.onCompleted()
                }
            })
        }
    }
}

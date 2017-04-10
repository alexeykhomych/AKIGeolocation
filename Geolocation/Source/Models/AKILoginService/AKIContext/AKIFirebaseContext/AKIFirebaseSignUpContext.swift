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

import Result

class AKIFirebaseSignUpContext: AKIContextProtocol{
    
    typealias User = FIRUser
    typealias Signal = Observable<Result<User, AuthError>>
    
    var userModel: AKIUser
    
    required init(_ userModel: AKIUser) {
        self.userModel = userModel
    }
    
    internal func execute() -> Signal {
        return Observable.create { observer in
            let user = self.userModel
            FIRAuth.auth()?.createUser(withEmail: user.email,
                                       password: user.password,
                                       completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    func userCompletionHandler(_ observer: AnyObserver<Result<FIRUser, AuthError>>?) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            
            if let error = error {
                observer?.onNext(.failure(.description(error.localizedDescription)))
                return
            }
            
            let userModel = self.userModel
            
            let values = [Context.Request.name: userModel.name,
                          Context.Request.email: userModel.email,
                          Context.Request.password: userModel.password]
            
            self.updateChildValues(Context.Request.users, observer: observer!, values: values, block: {
                guard let user = user else {
                    observer?.onNext(.failure(.emptyUser))
                    return
                }
                
                observer?.onNext(.success(user))
                observer?.onCompleted()
            })
        }
    }
}

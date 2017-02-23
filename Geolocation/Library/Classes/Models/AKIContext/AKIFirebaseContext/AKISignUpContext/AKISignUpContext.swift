//
//  AKISignUpContext.swift
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

class AKISignUpContext: AKIContextProtocol{
    
    var model: AKIUser
    
    required init(_ model: AKIUser) {
        self.model = model
    }
    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            let model = self.model
            FIRAuth.auth()?.createUser(withEmail: model.email!,
                                       password: model.password!,
                                       completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    func userCompletionHandler(_ observer: AnyObserver<AKIUser>) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            if error != nil {
                observer.onError(error!)
            }
            
            let model = self.model
            
            let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
            let userReference = reference.child(Context.Request.users).child(Context.Request.users)
            
            let values = [Context.Request.name: model.name,
                          Context.Request.email: model.email,
                          Context.Request.password: model.password]
            
            userReference.updateChildValues(values, withCompletionBlock: self.updateCompletionBlock())
            
            model.id = user?.uid
            
            observer.onCompleted()
        }
    }
    
    func updateCompletionBlock() -> (Error?, FIRDatabaseReference) -> () {
        return { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
        }
    }
}

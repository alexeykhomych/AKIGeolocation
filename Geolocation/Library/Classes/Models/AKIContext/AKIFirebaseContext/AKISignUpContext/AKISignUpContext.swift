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
    
    var userModel: AKIUser?
    
    required init(_ userModel: AKIUser?) {
        self.userModel = userModel
    }
    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            guard let user = self.userModel else {
                return Disposables.create()
            }
            
            guard let email = user.email else {
                return Disposables.create()
            }
            
            guard let password = user.password else {
                return Disposables.create()
            }
            
            FIRAuth.auth()?.createUser(withEmail: email,
                                       password: password,
                                       completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    func userCompletionHandler(_ observer: AnyObserver<AKIUser>?) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            
            if error != nil {
                observer?.onError(error!)
            }
            
            guard var model = self.userModel else {
                return
            }

            let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
            let userReference = reference.child(Context.Request.users).child(Context.Request.users)
            
            let values = [Context.Request.name: model.name,
                          Context.Request.email: model.email,
                          Context.Request.password: model.password]
            
            userReference.updateChildValues(values, withCompletionBlock: self.updateCompletionBlock())
            
            model.id = user?.uid
            
            observer?.onNext(model)
            observer?.onCompleted()
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

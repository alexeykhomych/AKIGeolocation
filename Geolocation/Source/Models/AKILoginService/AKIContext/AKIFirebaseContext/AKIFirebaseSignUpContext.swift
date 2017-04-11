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
            let reference = self.reference
            let query = self.query(.putUser(userId: user?.uid ?? "", name: userModel.name, email: userModel.email, password: userModel.password), reference: reference)
            query.observeSingleEvent(of: .value, with: { dataSnapshot in
                let dictionary = dataSnapshot.value as? NSDictionary
                
//                observer?.onNext(.success(dataSnapshot))
            }) { error in
                observer?.onNext(.failure(.description("SignUp context error - 79")))
            }
        }
    }
    
    let reference = FIRDatabase.database().reference()
    
    func query(_ target: Firebase, reference: FIRDatabaseReference) -> FIRDatabaseQuery {
        return target.firebaseQuery(reference)
    }
}

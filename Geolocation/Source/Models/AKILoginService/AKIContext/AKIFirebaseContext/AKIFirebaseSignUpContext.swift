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

    typealias Signal = Observable<Result<FIRUser, AuthError>>
    
    //MARK: - Accessors
    
    let reference = FIRDatabase.database().reference()
    
    var userModel: AKIUser
    
    //MARK: - Initializations and Deallocations
    
    init(_ userModel: AKIUser) {
        self.userModel = userModel
    }
    
    //MARK: - Public methods
    
    func execute() -> Signal {
        return Observable.create { observer in
            let user = self.userModel
            FIRAuth.auth()?.createUser(withEmail: user.email,
                                       password: user.password,
                                       completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    //MARK: - Private methods
    
    private func userCompletionHandler(_ observer: AnyObserver<Result<FIRUser, AuthError>>?) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            if let error = error {
                observer?.onNext(.failure(.description(error.localizedDescription)))
                return
            }

            let userModel = self.userModel
            let reference = self.reference
            _ = self.query(.putUser(userId: user?.uid ?? "", name: userModel.name, email: userModel.email, password: userModel.password), reference: reference)
            
            guard let user = user else {
                observer?.onNext(.failure(.description("Empty user")))
                return
            }
            
            observer?.onNext(.success(user))
        }
    }
}

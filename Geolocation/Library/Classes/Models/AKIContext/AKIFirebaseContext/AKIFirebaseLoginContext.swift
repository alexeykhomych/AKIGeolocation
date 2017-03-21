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

class AKIFirebaseLoginContext: AKIContextProtocol {
    
    var userModel: AKIUser?
    
    required init(_ userModel: AKIUser?) {
        self.userModel = userModel
    }
    
    internal func execute() -> Observable<AKIUser> {        
        return Observable.create { observer in
            guard let model = self.userModel else {
                return Disposables.create()
            }
            
            FIRAuth.auth()?.signIn(withEmail: model.email, password: model.password, completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }

    func login(with accessFacebookToken: String?) -> Observable<AKIUser> {
        return Observable.create { observer in
            guard let accessFacebookToken = accessFacebookToken else { return Disposables.create() }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessFacebookToken)
            FIRAuth.auth()?.signIn(with: credential, completion: self.userCompletionHandler(observer))
            
            return Disposables.create()
        }
    }
    
    private func userCompletionHandler(_ observer: AnyObserver<AKIUser>?) -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            if let error = error {
                observer?.on(.error(error))
                return
            }
            
            var model = AKIUser()
            model.id = user?.uid ?? ""
            observer?.onNext(model)
            observer?.onCompleted()
        }
    }
}

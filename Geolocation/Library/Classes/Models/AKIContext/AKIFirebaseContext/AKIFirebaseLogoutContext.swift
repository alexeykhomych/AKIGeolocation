//
//  AKIFirebaseLogoutContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import RxCocoa
import RxSwift

class AKIFirebaseLogoutContext: AKIContextProtocol {    
    internal func execute() -> Observable<Bool> {
        return Observable.create { observer in
            
            // MARK: need to refactor
            
            do {
                try FIRAuth.auth()?.signOut()
            } catch let signOutError as NSError {
                observer.onError(signOutError)
            }
            
            observer.onNext((FIRAuth.auth()?.currentUser == nil))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

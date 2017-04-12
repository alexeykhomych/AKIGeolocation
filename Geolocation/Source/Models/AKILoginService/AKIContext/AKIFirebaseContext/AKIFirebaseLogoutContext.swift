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

import Result

class AKIFirebaseLogoutContext: AKIContextProtocol {
    
    typealias Signal = Observable<Result<Bool, AuthError>>
    
    internal func execute() -> Signal {
        return Observable.create { observer in
            do {
                try FIRAuth.auth()?.signOut()
            } catch let signOutError as NSError {
                observer.onNext(.failure(.description(signOutError.localizedDescription)))
            }
            
            observer.onNext(.success((FIRAuth.auth()?.currentUser == nil)))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

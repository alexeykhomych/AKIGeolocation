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
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            
            try? FIRAuth.auth()?.signOut()
    
            observer.onNext(AKIUser())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

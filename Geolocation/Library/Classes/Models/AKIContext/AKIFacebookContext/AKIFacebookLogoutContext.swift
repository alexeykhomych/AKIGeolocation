//
//  AKIFacebookLogoutContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import Firebase
import FirebaseAuth

import RxSwift
import RxCocoa

class AKIFacebookLogoutContext: AKIContextProtocol {
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            
            FBSDKLoginManager.init().logOut()
            
            observer.onNext(AKIUser())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }    
}

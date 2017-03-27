//
//  AKIFacebookLogoutContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import RxSwift
import RxCocoa

class AKIFacebookLogoutContext: AKIContextProtocol {
    internal func execute() -> Observable<Bool> {
        return Observable.create { observer in
            
            FBSDKLoginManager.init().logOut()
            
            observer.onNext(FBSDKAccessToken.current() == nil)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }    
}

//
//  AKIFacebookLoginContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import Firebase
import FirebaseAuth

import RxSwift
import RxCocoa

class AKIFacebookLoginContext {    
    internal func execute(viewController: UIViewController) -> Observable<FBSDKAccessToken> {
        return Observable.create { observer in
            FBSDKLoginManager().logIn(withReadPermissions: [Context.Permission.publicProfile], from: viewController, handler: ({ result, error in
                
                let token = result?.token
                
                if error != nil || token == nil {
                    observer.onError(error ?? RxError.unknown)
//                    return
                } else {
                    observer.onNext(token!)
                }
                
                observer.onCompleted()
            }))

            return Disposables.create()
        }
    }
    
    func loginWithToken() -> Observable<FBSDKAccessToken> {
        return Observable.create { observer in
            observer.onNext(FBSDKAccessToken.current())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

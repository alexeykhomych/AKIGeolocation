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

class AKIFacebookLoginContext: AKIContextProtocol {    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            FBSDKLoginManager().logIn(withReadPermissions: [Context.Permission.publicProfile], from: nil, handler: ({ result, error in
                
                if let error = error {
                    observer.on(.error(error))
                    return
                }
                
                guard let result = result else { return }
                
                var model = AKIUser()
                model.id = result.token.userID
                
                _ = AKIFirebaseLoginContext(model).login(with: FBSDKAccessToken.current().tokenString).subscribe(onNext: { userModel in
                    observer.onNext(userModel)
                    observer.onCompleted()
                })
            }))

            return Disposables.create()
        }
    }
    
    func loginWithToken() -> Observable<AKIUser> {
        return Observable.create { observer in
            var user = AKIUser()
            user.id = FBSDKAccessToken.current().tokenString
            observer.onNext(user)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}



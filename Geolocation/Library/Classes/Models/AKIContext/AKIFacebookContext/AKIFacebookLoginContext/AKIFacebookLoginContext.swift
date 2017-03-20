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
    
    var accessTokenString: String {
        return FBSDKAccessToken.current().tokenString
    }
    
    var credentials: FIRAuthCredential {
        return FIRFacebookAuthProvider.credential(withAccessToken: self.accessTokenString)
    }
    
    var accessToken: FBSDKAccessToken? {
        return FBSDKAccessToken.current()
    }
    
    var parameters: [AnyHashable: Any] {
        return [Context.Request.fields : "\(Context.Request.id), \(Context.Request.name), \(Context.Request.email)"]
    }
    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            
            FBSDKLoginManager().logIn(withReadPermissions: [Context.Permission.publicProfile], from: nil, handler: ({ result, error in
                
                if let error = error {
                    observer.on(.error(error))
                    return
                }
                
                guard let result = result else {
                        return
                }
                var model = AKIUser()
                model.id = result.token.userID
                
                observer.onNext(model)
                observer.onCompleted()
            }))

            return Disposables.create()
        }
    }
}



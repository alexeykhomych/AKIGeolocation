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

protocol ContextProtocol: class {
    
    init(_ model: AnyObject)
    
    func execute() -> Observable<AnyObject>
    func parseJSON(_ json: Any)
    
}

class AKIFacebookLoginContext {
    
    private var model: AKIModel
    
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
    
    required init(_ model: AKIModel) {
        self.model = model
    }
    
    //MARK: RxSwift
    
    func loginFacebook() -> Observable<AnyObject> {
        return Observable.create { observer in
            let model = self.model as? AKIUser
            
            FIRAuth.auth()?.signIn(with: self.credentials, completion: { (user, error) in
                if error != nil {
                    observer.on(.error(error!))
                    return
                }
                
                model?.id = user?.uid
                model?.email = user?.email
            })            
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}

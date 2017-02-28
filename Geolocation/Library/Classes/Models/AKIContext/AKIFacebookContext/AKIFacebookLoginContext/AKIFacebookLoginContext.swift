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
    
    var controller: UIViewController?
    
    var model: AKIViewModel?
    
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
    
    required init(_ model: AKIViewModel) {
        self.model = model
    }
    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            
            FBSDKLoginManager.init().logIn(withReadPermissions: [Context.Permission.publicProfile], from: self.controller, handler: ({ result, error in
                
                if (error != nil) || (result == nil) {
                    return
                }
                
                FIRAuth.auth()?.signIn(with: self.credentials, completion: { (user, error) in
                    if error != nil {
                        observer.on(.error(error!))
                        return
                    }
                    
                    self.model?.model?.id = user?.uid
                })
                
                observer.onCompleted()
            }))
            
//            FBSDKGraphRequest(graphPath: Context.Request.facebookMe, parameters: self.parameters).start(completionHandler: { (connection, result, error) in
//                if error != nil {
//                    observer.on(.error(error!))
//                    return
//                }
//                
//                self.parseJSON(result!)
//            })
            
            return Disposables.create()
        }
    }
    
    func parseJSON(_ json: Any) {
        if let dictionary = json as? NSDictionary {
            let user = self.model?.model
            user?.email = dictionary[Context.Request.email] as? String
            user?.name = dictionary[Context.Request.name] as? String
        }
    }
}

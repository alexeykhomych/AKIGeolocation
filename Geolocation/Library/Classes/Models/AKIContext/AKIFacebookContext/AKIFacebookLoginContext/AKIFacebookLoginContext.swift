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

class AKIFacebookLoginContext: AKIContext {
    
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
        return [kAKIRequestFields : "\(kAKIRequestID), \(kAKIRequestName), \(kAKIRequestEmail)"]
    }
    
    override func performExecute() {
        self.signInWithFirebase()
        self.signInWithFacebook()
    }
    
    func contextCompleted() {
        AKIViewController.observer?.onCompleted()
    }
    
    func signInWithFirebase() {
        FIRAuth.auth()?.signIn(with: self.credentials, completion: { (user, error) in
            if error != nil {
                return
            }
            
            let model = self.model as? AKIUser
            model?.id = user?.uid
        })
    }
    
    func signInWithFacebook() {
        FBSDKGraphRequest(graphPath: kAKIFacebookRequestMe, parameters: self.parameters).start(completionHandler: { (connection, result, error) in
            if error != nil {
                self.errorMessage = error?.localizedDescription
                return
            }
            
            self.parseJSON(result!)
            self.contextCompleted()
        })
    }
    
    func parseJSON(_ json: Any) {
        if let dictionary = json as? NSDictionary {
            let model = self.model as? AKIUser
            model?.email = dictionary[kAKIRequestEmail] as? String
            model?.name = dictionary[kAKIRequestName] as? String
            model?.password = dictionary[kAKIRequestPassword] as? String
        }
    }
}

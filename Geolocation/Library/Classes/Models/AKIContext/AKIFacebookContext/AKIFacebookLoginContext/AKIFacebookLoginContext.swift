//
//  AKIFacebookLoginContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

class AKIFacebookLoginContext: AKIContext {
    
    var accessToken: FBSDKAccessToken? {
        return FBSDKAccessToken.current()
    }
    
    var parameters: [AnyHashable : Any] {
        return [kAKIRequestFields : "\(kAKIRequestID), \(kAKIRequestName), \(kAKIRequestEmail)"]
    }
    
    override func performExecute() {
        FBSDKGraphRequest(graphPath: kAKIFacebookRequestMe, parameters: self.parameters).start {
            (connection, result, error) in
            
            if error != nil {
                self.errorMessage = error?.localizedDescription
                return
            }
            
            self.parseJSON(result!)
            self.contextCompleted()
        }
    }
    
    func contextCompleted() {
        AKIViewController.observer?.onCompleted()
    }
    
    func parseJSON(_ json: Any) {
        if let dictionary = json as? NSDictionary {
            let model = self.model as? AKIUser
            model?.name = dictionary[kAKIRequestName] as? String
            model?.email = dictionary[kAKIRequestEmail] as? String
        }
    }
}

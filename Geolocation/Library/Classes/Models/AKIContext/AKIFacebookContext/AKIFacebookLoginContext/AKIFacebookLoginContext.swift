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
        return [kAKIFacebookRequestFields : "\(kAKIFacebookRequestID), \(kAKIFacebookRequestName), \(kAKIFacebookRequestEmail)"]
    }
    
    override func performExecute() {
        FBSDKGraphRequest(graphPath: kAKIFacebookRequestMe, parameters: self.parameters).start {
            (connection, result, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            print(result)
            let model = self.model as? AKIUser
            
            
        }
    }
    
}

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
                self.errorMessage = error?.localizedDescription
                return
            }
            
            self.parseJSON(result)
            
            self.contextCompleted()
        }
    }
    
    func contextCompleted() {
        AKIViewController.observer?.onCompleted()
    }
    
    func parseJSON(_ json: Any) {
        if let json = json as? NSDictionary {
            guard let data = json[0] as? [String: Any] else {
                return
            }
            
            let model = self.model as? AKIUser
            model?.name = json["name"] as! String
            model?.name
            
//            guard let dictionary = data[0] as? [String: Any] else { return }
            
            
        }
        
        
        
    }
}

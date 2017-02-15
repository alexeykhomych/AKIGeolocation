//
//  AKIContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKIContext {
    
    var errorMessage: String?
    
    var model: AnyObject? = nil
    
    func performExecute() {
        
    }
    
    func execute() {
        DispatchQueue.global().async {
            self.performExecute()
        }
    }

}

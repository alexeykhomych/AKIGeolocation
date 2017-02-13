//
//  AKICurrentPositionContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FirebaseDatabase

class AKICurrentPositionContext: AKIContext {

    override func performExecute() {
        let reference = FIRDatabase.database().reference(fromURL: kAKIFirebaseURL)
        reference.updateChildValues(["some": "some"])
    }
    
}

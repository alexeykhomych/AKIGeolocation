//
//  Firebase+Extensions.swift
//  Geolocation
//
//  Created by Alexey Khomych on 4/10/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

enum Firebase {
    case putUser(user: AKIUser)
    case updateUser(user: AKIUser, fields: [String: Any])
    case getUser(userId: String)
    case currentPosition(user: AKIUser, coordinates: [String: Any])
}

extension Firebase {
    
    public typealias FirebaseQueryType = FIRDatabaseQuery
    
    public func firebaseQuery(_ reference: FIRDatabaseReference) -> FirebaseQueryType {
        switch self {
        case .putUser(let user):
            let userPath = self.composeFirebaseNodePath(Context.Request.users, user.id)
            let userRef = reference.child(userPath)
            let user: [String : Any] = [Context.Request.name: user.name,
                                       Context.Request.email: user.email,
                                       Context.Request.password: user.password]
            userRef.updateChildValues(user)
            return userRef
            
        case .getUser(let id):
            return reference.child(Context.Request.users + "/" + id)
        
        case .updateUser(let user, let fields):
            let userPath = self.composeFirebaseNodePath(Context.Request.users, user.id)
            let userRef = reference.child(userPath)
            let values = fields
            userRef.updateChildValues(values)
            return userRef
        
        case .currentPosition(let user, let coordinates):
            let userPath = self.composeFirebaseNodePath(Context.Request.coordinates, user.id)
            let userRef = reference.child(userPath)
            let values = coordinates
            userRef.updateChildValues(values)
            return userRef
        }
    }
    
    private func composeFirebaseNodePath(_ subpaths: String ...) -> String {
        return "/" + subpaths.reduce("") { $0 + "/" + $1 }
    }
}

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
    case putUser(userId: String, name: String, email: String, password: String)
    case updateUser(userId: String, fields: [String: Any])
    case getUser(String)
    case currentPosition(id: String, fields: [String: Any])
}

extension Firebase {
    
    public typealias FirebaseQueryType = FIRDatabaseQuery
    
    public func firebaseQuery(_ reference: FIRDatabaseReference) -> FirebaseQueryType {
        switch self {
        case .putUser(let id, let name, let email, let password):
            let userPath = self.composeFirebaseNodePath(Context.Request.users, id)
            let userRef = reference.child(userPath)
            let user: [String : Any] = [Context.Request.name: name,
                                       Context.Request.email: email,
                                       Context.Request.password: password]
            userRef.updateChildValues(user)
            return userRef
            
        case .getUser(let id):
            return reference.child(Context.Request.users + "/" + id)
        
        case .updateUser(let userId, let fields):
            let userPath = self.composeFirebaseNodePath(Context.Request.users, userId)
            let userRef = reference.child(userPath)
            let values = fields
            userRef.updateChildValues(values)
            return userRef
        
        case .currentPosition(let userId, let fields):
            let userPath = self.composeFirebaseNodePath(Context.Request.coordinates, userId)
            let userRef = reference.child(userPath)
            let values = fields
            userRef.updateChildValues(values)
            return userRef
        }
    }
    
    private func composeFirebaseNodePath(_ subpaths: String ...) -> String {
        return "/" + subpaths.reduce("") { $0 + "/" + $1 }
    }
}

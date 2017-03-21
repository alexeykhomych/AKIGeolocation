//
//  AKIFirebaseLoginProvider.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

protocol AKIFirebaseLoginProtocol {
    
    func login(with userModel: AKIUser?) -> Observable<AKIUser>
    
}

class AKIFirebaseLoginProvider: AKIFirebaseLoginProtocol {
       
    func login(with userModel: AKIUser?) -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(userModel).execute()
    }
    
    func loginWithAccessToken() -> Observable<AKIUser> {
        if FIRAuth.auth()?.currentUser == nil {
            return Observable<AKIUser>.empty()
        }
        
        let userModel = AKIUser()
//        userModel.id = (FIRAuth.auth()?.currentUser?.uid)!
        
        return self.login(with: userModel)
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFirebaseLogoutContext().execute()
    }
    
    func signup(with userModel: AKIUser?) -> Observable<AKIUser> {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
}

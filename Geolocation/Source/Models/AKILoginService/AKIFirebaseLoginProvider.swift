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
    
    func login(with userModel: AKIUser) -> Observable<AKIUser>
    
}

class AKIFirebaseLoginProvider: AKIFirebaseLoginProtocol {
       
    func login(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(userModel).execute()
    }
    
    func loginWithAccessToken(with userModel: AKIUser) -> Observable<AKIUser> {
        guard let user = FIRAuth.auth()?.currentUser else {
            return Observable<AKIUser>.empty()
        }
        
        var userModel = userModel
        userModel.id = user.uid
        
        return self.login(with: userModel)
    }
    
    func logout(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseLogoutContext(userModel).execute()
    }
    
    func signup(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
}

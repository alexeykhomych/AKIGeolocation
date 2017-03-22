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
       
    func login(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(userModel).execute()
    }
    
    func login(with accessToken: String?) -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(AKIUser()).login(with: accessToken)
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFirebaseLogoutContext().execute()
    }
    
    func signup(with userModel: AKIUser?) -> Observable<AKIUser> {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
}

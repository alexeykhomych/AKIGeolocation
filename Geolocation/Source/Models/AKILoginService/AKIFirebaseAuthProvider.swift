//
//  AKIFirebaseAuthProvider.swift
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

import FBSDKLoginKit

protocol AKIFirebaseAuthProtocol {
    associatedtype AccessToken
    
    func login(with userModel: AKIUser) -> Observable<AKIUser>
    func login(credential: AccessToken) -> Observable<AKIUser>
    func logout() -> Observable<AKIUser>
    func signup(with userModel: AKIUser) -> Observable<AKIUser>
}

class AKIFirebaseAuthProvider: AKIFirebaseAuthProtocol {
    
    typealias AccessToken = FBSDKAccessToken
    
    var currentUser:FIRUser? {
        return FIRAuth.auth()?.currentUser
    }
       
    func login(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(userModel).execute()
    }
    
    func login(credential: FBSDKAccessToken) -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(AKIUser()).login(with: credential)
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFirebaseLogoutContext().execute()
    }
    
    func signup(with userModel: AKIUser) -> Observable<AKIUser> {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
}

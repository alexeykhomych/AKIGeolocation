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
    
    func login(userModel: AKIUser) -> Observable<FIRUser>
    func logout() -> Observable<Bool>
    func signup(userModel: AKIUser) -> Observable<FIRUser>
}

class AKIFirebaseAuthProvider: AKIFirebaseAuthProtocol {
    
    typealias AccessToken = FBSDKAccessToken
       
    func login(userModel: AKIUser) -> Observable<FIRUser> {
        return AKIFirebaseLoginContext(userModel: userModel).execute()
    }
    
    func logout() -> Observable<Bool> {
        return AKIFirebaseLogoutContext().execute()
    }
    
    func signup(userModel: AKIUser) -> Observable<FIRUser> {
        return AKIFirebaseSignUpContext(userModel).execute()
    }
}

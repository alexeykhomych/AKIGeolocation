//
//  AKIFacebookLoginProvider.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/7/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

import RxSwift
import RxCocoa

protocol AKIFacebookLoginProtocol {
    func loginWithAccessToken() -> Observable<AKIUser>
    func login() -> Observable<AKIUser>
}

class AKIFacebookLoginProvider: AKIFacebookLoginProtocol {
    
    var userModel: AKIUser?
    
    var loginContext: AKIFacebookLoginContext?
//    var logoutContext: AKIFacebookLogoutContext?
    
    let disposeBag = DisposeBag()
    
    deinit {
//        self.loginContext.cancel()
//        self.logoutContext.cancel()
    }
    
    init(_ userModel: AKIUser) {
        self.userModel = userModel
    }
   
    func loginWithAccessToken() -> Observable<AKIUser> {
//        let accessToken = FBSDKAccessToken.current()
//        
//        var model = AKIUser()
//        
//        if accessToken != nil {
//            model.id = accessToken?.userID
//            
//            let controller = AKILocationViewController()
//            controller.userModel = model
//            self.pushViewController(controller)
//        }
        fatalError()
    }
    
    func login() -> Observable<AKIUser> {
        return AKIFacebookLoginContext(self.userModel).execute()
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFacebookLogoutContext(self.userModel).execute()
    }
    
    func backgroundDispatchQueue() -> ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background))
    }
    
}

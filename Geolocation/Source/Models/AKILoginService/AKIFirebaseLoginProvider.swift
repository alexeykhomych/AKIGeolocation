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

protocol AKIFirebaseLoginProtocol {
    
    func login() -> Observable<AKIUser>
    
}

class AKIFirebaseLoginProvider: AKIFirebaseLoginProtocol {
    
    var userModel: AKIUser?

    init(_ userModel: AKIUser) {
        self.userModel = userModel
    }
       
    func login() -> Observable<AKIUser> {
        return AKIFirebaseLoginContext(self.userModel).execute()
    }
    
    func logout() -> Observable<AKIUser> {
        return AKIFirebaseLogoutContext(self.userModel).execute()
    }
    
    func backgroundDispatchQueue() -> ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background))
    }
    
}

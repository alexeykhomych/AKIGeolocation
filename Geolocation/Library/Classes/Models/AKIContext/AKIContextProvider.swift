//
//  AKIContextProvider.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/24/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AKIContextProvider: AKIContextProtocol {
    
    internal var userModel: AKIUser?
    
    internal  required init(_ userModel: AKIUser?) {
        self.userModel = userModel
    }
    
    internal func execute() -> Observable<AKIUser> {
        print("reload execute method in child")
        fatalError()
    }

}

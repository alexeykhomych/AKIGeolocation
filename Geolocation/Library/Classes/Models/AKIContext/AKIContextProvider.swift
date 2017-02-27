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

    internal var model: AKIViewModel?
    
    internal  required init(_ model: AKIViewModel) {
        self.model = model
    }
    
    internal func execute() -> Observable<AKIUser> {
        //АПАСНАСТЬ
        fatalError()
        return self.execute()
    }
    
}

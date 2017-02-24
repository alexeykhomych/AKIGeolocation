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

extension AKIContextProvider {
    
//    func contextType() -> AKIContextProtocol {
//        let model = self.model
//        if (model?.id?.isEmpty)! {
//            return 
//        }
//    }
}

class AKIContextProvider: AKIContextProtocol {

    internal var model: AKIUser?
    
    internal  required init(_ model: AKIUser) {
        self.model = model
        //определить тип контекста и выполнить execute
    }
    
    internal func execute() -> Observable<AKIUser> {
        //АПАСНАСТЬ
        fatalError()
        return self.execute()
    }
    
}

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
    
    internal var viewModel: AKIViewModel?
    
    internal  required init(_ viewModel: AKIViewModel?) {
        self.viewModel = viewModel
    }
    
    internal func execute() -> Observable<AKIUser> {
        print("reload execute method in child")
        fatalError()
    }

}

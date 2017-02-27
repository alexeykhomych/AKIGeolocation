//
//  AKIContextProtocol.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/17/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

protocol AKIContextProtocol {
    associatedtype AKIContext
    
    func execute() -> Observable<AKIContext>
}



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

extension AKIContextProtocol {
    
    func fillModel(with json: NSDictionary) {
        self.model?.id = json["uid"] as? String
        self.model?.email = json["email"] as? String
    }
}

protocol AKIContextProtocol {
    associatedtype Valaue
    
//    
//    var model: AKIUser? { get set }
//    
//    init(_ model: AKIUser)
    
    func execute() -> Observable<Valaue>
}



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
import Result
import Firebase
import FirebaseAuth

extension AKIContextProtocol {    
    func query(_ target: Firebase, reference: FIRDatabaseReference) -> FIRDatabaseQuery {
        return target.firebaseQuery(reference)
    }
}

protocol AKIContextProtocol {
    associatedtype Value
    
    func execute() -> Observable<Value>
}

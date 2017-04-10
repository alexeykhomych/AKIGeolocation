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

//extension AKIContextProtocol {
//    typealias Signal = AnyObserver<Result<User, AuthError>>
//    
//    func updateChildValues(_ pathString: String,
//                           observer: Signal,
//                           values: [String : Any],
//                           block: @escaping ((Void) -> ()))
//    {
//        let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
//        let userReference = reference.child(Context.Request.coordinates).child(pathString)
//        userReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
//            if let error = error {
//                observer.onNext(.failure(.description(error.localizedDescription)))
//                return
//            }
//            
//            block()
//        })
//    }
//}

protocol AKIContextProtocol {
    associatedtype Value
    
    func execute() -> Observable<Value>
}

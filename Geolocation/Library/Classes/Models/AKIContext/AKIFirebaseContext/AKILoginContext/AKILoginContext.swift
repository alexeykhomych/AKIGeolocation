//
//  AKILoginContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import RxCocoa
import RxSwift

class AKILoginContext: AKIContextProtocol {
    
    var viewModel: AKIViewModel?
    
    required init(_ viewModel: AKIViewModel?) {
        self.viewModel = viewModel
    }
    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { [weak self] observer in
            let model = self?.viewModel?.model
            
            guard let email = model?.email else {
                return Disposables.create()
            }
            
            guard let password = model?.password else {
                return Disposables.create()
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    observer.on(.error(error))
                    return
                }
                
                model?.id = user?.uid
                observer.onNext(model!)
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}

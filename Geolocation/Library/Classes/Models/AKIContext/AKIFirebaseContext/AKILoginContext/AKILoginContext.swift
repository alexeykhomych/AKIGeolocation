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
    
    required init(_ viewModel: AKIViewModel) {
        self.viewModel = viewModel
    }
    
    internal func execute() -> Observable<AKIUser> {
        return Observable.create { observer in
            let model = self.viewModel?.model
            FIRAuth.auth()?.signIn(withEmail: (model?.email!)!, password: (model?.password!)!, completion: { (user, error) in
                if error != nil {
                    observer.on(.error(error!))
                    return
                }
                
                model?.id = user?.uid
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}

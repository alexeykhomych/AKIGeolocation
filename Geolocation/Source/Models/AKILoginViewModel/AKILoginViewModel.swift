//
//  AKILoginViewModel.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/21/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

//protocol loginWithFacebook {
//    var loginFacebookContext: AKIFacebookLoginContext? { get set }
//}
//
//extension AKILoginViewModel: loginWithFacebook {
//    internal var loginFacebookContext: AKIFacebookLoginContext? {
//        get {
//            return self.loginFacebookContext
//        }
//        set(newContext) {
//            AKIFacebookLoginContext(self.model!)
//        }
//    }
//}

class AKILoginViewModel {
    private let loginContext: AKILoginContext
    private let disposeBag = DisposeBag()
    
    var model: AKIUser?
    
    private let user: Observable<AKIUser>
    
    let name:       Observable<String>
    let password:   Observable<String>
    let email:      Observable<String>
    let id:         Observable<String>
    
    init(_ model: AKIUser) {
        self.model = model
        let loginContext = AKILoginContext(model)
        let user = loginContext.execute().asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .shareReplay(1)
        
        self.user = user 
        
        self.name = user.map { $0.name ?? "" }
        self.password = user.map { $0.password ?? "" }
        self.email = user.map { $0.email ?? "" }
        self.id = user.map { $0.id ?? "" }
        
        self.loginContext = loginContext
    }
    
//    func validateFields() -> Bool {
//        return self.nameValidation(self.name) &&
//            self.emailValidation(self.email) &&
//            self.passwordValidation(self.password)
//    }
    
    private func nameValidation(_ name: String) -> Bool {
        return name.nameValidation()
    }
    
    private func passwordValidation(_ password: String) -> Bool {
        return password.passwordValidation()
    }
    
    private func emailValidation(_ email: String) -> Bool {
        return email.emailValidation()
    }
}

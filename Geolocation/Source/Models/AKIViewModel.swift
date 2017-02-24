//
//  AKIViewModel.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/24/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

protocol AKIUserViewModelProtocol: AKIUserObserverViewModelProtocol {
    var model: AKIUser? { get set }
    var context: AKIContextProtocol? { get set }
    
    init(_ model: AKIUser)
    func nameValidation(_ name: String) -> Bool
    func passwordValidation(_ password: String) -> Bool
    func emailValidation(_ email: String) -> Bool
}

extension AKIUserViewModelProtocol {
    
    func nameValidation(_ name: String) -> Bool {
        return name.nameValidation()
    }
    
    func passwordValidation(_ password: String) -> Bool {
        return password.passwordValidation()
    }
    
    func emailValidation(_ email: String) -> Bool {
        return email.emailValidation()
    }
    
    func validateFields(_ model: AKIUser) -> Bool {
        return  self.nameValidation(model.name!) &&
                self.emailValidation(model.email!) &&
                self.passwordValidation(model.password!)
    }
    
    mutating func fillModel(_ email: String, password: String) {
        let user = self.model
        user?.password = password
        user?.email = email
        
        if !self.validateFields(user!) {
            return
        }
        
        let context = AKIContextProvider(user!)
        self.context = context
        self.observingForProperties(context)
    }
    
    mutating func fillModel(_ email: String, password: String, name: String) {
        let user = self.model
        user?.password = password
        user?.email = email
        
        if !self.validateFields(user!) {
            return
        }
        
        self.context = AKISignUpContext(user!)
    }
}

protocol AKIUserObserverViewModelProtocol {
    
    var name:       Observable<String>? { get set }
    var password:   Observable<String>? { get set }
    var email:      Observable<String>? { get set }
    var id:         Observable<String>? { get set }
    
    func observingForProperties(_ context: AKIContextProvider)
}

class AKIViewModel: AKIUserViewModelProtocol {
    
    internal var id: Observable<String>?
    internal var email: Observable<String>?
    internal var password: Observable<String>?
    internal var name: Observable<String>?

    internal var model: AKIUser?
    internal var context: AKIContextProtocol?

    let disposeBag = DisposeBag()

    required init(_ model: AKIUser) {
        self.model = model
    }
    
    internal func observingForProperties(_ context: AKIContextProvider) {
        let user = context.execute().asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .shareReplay(1)
        
        self.name = user.map { $0.name ?? "" }
        self.password = user.map { $0.password ?? "" }
        self.email = user.map { $0.email ?? "" }
        self.id = user.map { $0.id ?? "" }
    }

}

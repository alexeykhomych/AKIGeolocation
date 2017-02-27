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
        return  self.emailValidation(model.email!) &&
                self.passwordValidation(model.password!)
    }
    
    mutating func fillModel(_ email: String, password: String) {
        let user = self.model
        user?.password = password
        user?.email = email
        
        if !self.validateFields(user!) {
            return
        }
        
    }
}

protocol AKIUserObserverViewModelProtocol {
    var name:       Variable<String>? { get set }
    var password:   Variable<String>? { get set }
    var email:      Variable<String>? { get set }
    var id:         Observable<String>? { get set }
}

class AKIViewModel: AKIUserViewModelProtocol {
    
    internal var id: Observable<String>?
    internal var email: Variable<String>?
    internal var password: Variable<String>?
    internal var name: Variable<String>?

    internal var model: AKIUser?

    let disposeBag = DisposeBag()

    required init(_ model: AKIUser) {
        self.model = model
        self.password = Variable<String>("")
        self.email = Variable<String>("")
        self.name = Variable<String>("")
        self.fillModelWithObservingProperties()
    }
    
    private func fillModelWithObservingProperties() {
        let user = self.model
        _ = self.email?.asObservable().subscribe(onNext: { result in
            
            if self.emailValidation(result) {
                user?.email = result
            }
            
        }).disposed(by: self.disposeBag)
        
        _ = self.password?.asObservable().subscribe(onNext: { result in
            
            if self.passwordValidation(result) {
                user?.password = result
            }
            
        }).disposed(by: self.disposeBag)
        
        _ = self.name?.asObservable().subscribe(onNext: { result in
            
            if self.nameValidation(result) {
                user?.name = result
            }
            
        }).disposed(by: self.disposeBag)
    }
}

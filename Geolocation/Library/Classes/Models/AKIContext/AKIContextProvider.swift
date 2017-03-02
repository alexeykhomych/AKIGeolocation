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

protocol ContextProvider {
    associatedtype Context
    var contexts: [Context]? { get set }
}

extension ContextProvider {
    
    mutating func enqueue(element:Context){
        contexts?.append(element)
    }
    
    mutating func dequeue() -> Context{
        return (contexts?.remove(at: 0))!
    }
    
    func getContext() -> Context? {
        return self.contexts.flatMap { $0 as? Context }
    }
}

class AKIContextProvider: ContextProvider, AKIContextProtocol {
    internal var contexts: [AKIContextProtocol]?

    typealias Context = AKIContextProtocol

    
    internal var viewModel: AKIViewModel?
    
    internal  required init(_ viewModel: AKIViewModel?) {
        self.viewModel = viewModel
        self.initContexts()
    }
    
    private func initContexts() {
        let q = AKILoginContext(self.viewModel)
        
        let w = self.contexts
        
        if var w = w as? AKILoginContext {
            w.enqueue(element: q)
        }
        
        self.enqueue(element: q)
    }
    
    internal func execute() -> Observable<AKIUser> {
        print("reload execute method in child")
        fatalError()
    }
    
}

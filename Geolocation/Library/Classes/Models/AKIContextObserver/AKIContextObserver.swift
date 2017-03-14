//
//  AKIContextObserver.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

protocol contextObserver {
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onNextBlock: @escaping (() -> Void))
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onCompletedBlock: @escaping (() -> Void))
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?,
                            onNextBlock: @escaping (() -> Void),
                            onErrorBlock: @escaping (() -> Void))
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?,
                            onCompletedBlock: @escaping (() -> Void),
                            onErrorBlock: @escaping (() -> Void))
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?,
                            onNextBlock: @escaping (() -> Void),
                            onCompletedBlock: @escaping (() -> Void),
                            onErrorBlock: @escaping (() -> Void))
    
}

extension contextObserver {
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onCompletedBlock: @escaping (() -> Void)) {
        self.subscribeToContext(context, onNextBlock: { }, onCompletedBlock: onCompletedBlock, onErrorBlock: { })
    }
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onCompletedBlock: @escaping (() -> Void), onErrorBlock: @escaping (() -> Void)) {
        self.subscribeToContext(context, onNextBlock: { }, onCompletedBlock: onCompletedBlock, onErrorBlock: onErrorBlock)
    }
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onNextBlock: @escaping (() -> Void)) {
        self.subscribeToContext(context, onNextBlock: onNextBlock, onErrorBlock: { })
    }
        
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onNextBlock: @escaping (() -> Void), onErrorBlock: @escaping (() -> Void)) {
        self.subscribeToContext(context, onNextBlock: onNextBlock, onCompletedBlock: {  }, onErrorBlock: onErrorBlock)
    }
    
    func subscribeToContext<R:AKIContextProtocol>(_ context: R?, onNextBlock: @escaping (() -> Void), onCompletedBlock: @escaping (() -> Void), onErrorBlock: @escaping (() -> Void)) {
        let contextSubscriber = context?.execute().subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
        
        _ = contextSubscriber?.subscribe(onNext: { result in
            onNextBlock()
        }, onError: { _ in
            onErrorBlock()
        }, onCompleted: { _ in
            onCompletedBlock()
        }, onDisposed: { _ in
            
        })
    }
}

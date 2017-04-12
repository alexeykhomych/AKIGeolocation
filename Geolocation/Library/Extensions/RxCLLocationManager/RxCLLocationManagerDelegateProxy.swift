//
//  RxCLLocationManagerDelegateProxy.swift
//  RxExample
//
//  Created by Carlos García on 8/7/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

struct NewRxCLLocationManagerDelegateProxy {
    static func currentDelegateFor(_ object: CLLocationManager) -> DelegateProxy? {
        return RxCLLocationManagerDelegateProxy.currentDelegateFor(object) as? DelegateProxy
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, toObject object: CLLocationManager) {
        RxCLLocationManagerDelegateProxy.setCurrentDelegate(delegate, toObject: object)
    }
    
    static func proxyForObject(_ object: CLLocationManager) -> DelegateProxy {
        return RxCLLocationManagerDelegateProxy.proxyForObject(object)
    }
}

class RxCLLocationManagerDelegateProxy : DelegateProxy, CLLocationManagerDelegate, DelegateProxyType {
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let locationManager: CLLocationManager = object as! CLLocationManager
        return locationManager.delegate
    }
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let locationManager: CLLocationManager = object as! CLLocationManager
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
}

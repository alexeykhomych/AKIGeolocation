//
//  RootViewGettable.swift
//  RootViewGettable
//
//  Created by Artem Chabannyi on 9/16/16.
//  Copyright © 2016 IDAP Group. All rights reserved.
//

import Foundation
import UIKit
import IDPCastable

public protocol RootViewGettable {
    
    associatedtype RootViewType: UIView
    
    var rootView: RootViewType? { get }
}

public extension RootViewGettable where Self : UIViewController {
    
    /**
     Cast viewIfLoaded property to RootViewType type and return result.
     This implementation use viewIfLoaded propery of UIViewController instance.
     */
    
    public var rootView: RootViewType? {
        return cast(self.viewIfLoaded)
    }
}

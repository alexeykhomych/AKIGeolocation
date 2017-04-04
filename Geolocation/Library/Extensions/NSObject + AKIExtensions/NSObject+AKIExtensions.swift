//
//  NSObject+AKIExtensions.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

extension NSObject {
    func cast<Type, Result>(_ value: Type) -> Result? {
        return value as? Result
    }
}

//
//  AKIContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/17/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

protocol AKIContext {
    var model: AKIModel { get set }
    init(_ model: AKIModel)
}

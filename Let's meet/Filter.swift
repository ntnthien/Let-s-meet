//
//  Filter.swift
//  Lets meet
//
//  Created by Nguyễn Thành Thực on 8/21/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation
import CoreLocation


//this class for filter
@objc
class Filter: NSObject {
    
    var location: CLLocation?
    
    init(location: CLLocation) {
        self.location = location
    }
}



//
//  StringHelper.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/16/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeDoudleWhitespaces() -> String {
        return self.replace("  ", replacement: " ")
    }
    
    func removeWhitespaces() -> String {
        return self.replace(" ", replacement: "")
    }
    
    
}
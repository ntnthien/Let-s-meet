//
//  NSUserDefault .swift
//  Lets meet
//
//  Created by Nguyễn Thành Thực on 8/23/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation


let kTags = "k_tags"
let kIsEnable = "k_isEnable"

extension NSUserDefaults {
    
    func setTags(tags: [String], forKey key: String) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(tags, forKey: key)
        userDefault.synchronize()
    }
    
    func getTagsForKey(key: String) -> [String]? {
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if let tags = userDefault.objectForKey(key) {
            return tags as? [String]
        } else {
            return nil
        }
    }
    
    func setIsEnableTags(isEnable: Bool, forKey key: String) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(isEnable, forKey: key)
        userDefault.synchronize()
    }
    
    func getIsEnableForKey(key: String) -> Bool? {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let value = userDefault.valueForKey(key) {
            return value as? Bool
        } else {
            return nil
        }
    }
    
}
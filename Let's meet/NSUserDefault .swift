//
//  NSUserDefault .swift
//  Lets meet
//
//  Created by Nguyễn Thành Thực on 8/23/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation


let kBeer = "k_beer"
let kBelgian = "k_begian"
let kClub = "kclub"
let kFestival = "k_festival"
let kMusic = "k_music"
let kFunc = "k_func"

extension NSUserDefaults {
    
    func setTag(tag: String, forKey key: String) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(tag, forKey: key)
        userDefault.synchronize()
    }
    
    func getTagForKey(key: String) -> String {
        let tag = NSUserDefaults.valueForKey(key) as! String
        return tag
    }
    
}
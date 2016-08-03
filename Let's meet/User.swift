//
//  User.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation

class User {
    
    static var _currentUser: User?
    
    var username: String?
    var password: String?
    var profileUrl: NSURL?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        username = dictionary["username"] as? String
        password = dictionary["password"] as? String
        
//        let profileUrlString = dictionary["profile_image_url_https"] as? String
//        if let profileUrlString = profileUrlString {
//            profileUrl = NSURL(string: profileUrlString)
//        }
    }
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(user, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
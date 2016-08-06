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
    
    var last_name: String?
    var first_name: String?
    var password: String?
    var profileUrl: NSURL?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        last_name = dictionary["last_name"] as? String
        first_name = dictionary["first_name"] as? String
        password = dictionary["password"] as? String
        
        if let picture = dictionary["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary,
            url = data["url"] as? String{
            profileUrl = NSURL(string: url)
        }
    }
    class var currentUser: User? {
        get {
            print("Get currentUser")
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
            print("Set currentUser")

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
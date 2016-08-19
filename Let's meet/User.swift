//
//  User.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation

class User {
    var uid: String
    var displayName: String!
    var email: String!
    var photoURL: String!
    var providerID: String
    
    func toJSON() -> [String: AnyObject] {
        let name = self.displayName
        let email = self.email
        let photoUrl = self.photoURL
        let uid = self.uid;
        let providerID = self.providerID
        
        return ["uid": uid, "name": name, "email": email, "photo_url": photoUrl, "provider_id": providerID]
    }
    
    init? (userInfo: [String: AnyObject]) {
        guard let uid = userInfo["uid"] as? String,
            displayName = userInfo["name"] as? String,
            email = userInfo["email"] as? String,
            photoUrl = userInfo["photo_url"] as? String,
            providerID = userInfo["provider_id"] as? String
            else { return nil }
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.photoURL = photoUrl
        self.providerID = providerID
    }
    
    init?(uid: String, displayName: String, email: String, photoURL: String, providerID: String) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.photoURL = photoURL
        self.providerID = providerID
    }
}
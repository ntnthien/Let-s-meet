//
//  Discussion.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/17/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation

struct Discussion {
    var discussion_id: String
    var content_type: String?
    var content_msg: String?
    var sender_id: String?
    var sender_name: String?
    var sender_photo: String?
    var time: NSTimeInterval?
    
    init (discussion_id: String, content_type: String?,content_msg: String?, sender_id: String?, sender_name: String?, sender_photo: String?, time: NSTimeInterval?) {
        self.discussion_id = discussion_id
        self.content_type = content_type
        self.content_msg = content_msg
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.sender_photo = sender_photo
        self.time = time
    }
    
    init? (discussion_id: String, discussionInfo: [String: AnyObject]) {
        self.discussion_id = discussion_id
        self.content_type = discussionInfo["content_type"] as? String
        self.content_msg = discussionInfo["content_msg"] as? String
        self.sender_id = discussionInfo["sender_id"] as? String
        self.sender_name = discussionInfo["sender_name"] as? String
        self.sender_photo = discussionInfo["sender_photo"] as? String
        self.time = discussionInfo["time"] as? NSTimeInterval
    }
    
    func toJSON() -> [String: AnyObject?] {
        return ["discussion_id": self.discussion_id, "content_type": self.content_type, "content_msg": self.content_msg, "sender_id": self.sender_id, "sender_name": self.sender_name, "sender_photo": self.sender_photo, "time": NSDate().timeIntervalSinceNow]
    }
    
}
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
    var media_type: String?
    var sender_id: String?
    var sender_name: String?
    var sender_photo: String?
    var time: NSTimeInterval?
    var content_msg: String?
    var file_Url: String?
    
    
    init (discussion_id: String, media_type: String?, sender_id: String?, sender_name: String?, sender_photo: String?, time: NSTimeInterval?, content_msg: String?, file_Url: String?) {
        self.discussion_id = discussion_id
        self.media_type = media_type
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.sender_photo = sender_photo
        self.time = time
        self.content_msg = content_msg
        self.file_Url = file_Url
    }
    
    init? (discussion_id: String, discussionInfo: [String: AnyObject]) {
        self.discussion_id = discussion_id
        self.media_type = discussionInfo["media_type"] as? String
        self.sender_id = discussionInfo["sender_id"] as? String
        self.sender_name = discussionInfo["sender_name"] as? String
        self.sender_photo = discussionInfo["sender_photo"] as? String
        self.time = discussionInfo["time"] as? NSTimeInterval
        self.content_msg = discussionInfo["content_msg"] as? String
        self.file_Url = discussionInfo["file_Url"] as? String
    }
    
    func toJSON() -> [String: AnyObject?] {
        return ["discussion_id": self.discussion_id, "media_type": self.media_type, "sender_id": self.sender_id, "sender_name": self.sender_name, "sender_photo": self.sender_photo, "time": NSDate().timeIntervalSinceNow, "content_msg": self.content_msg, "file_Url": self.file_Url]
    }
    
}
//
//  Event.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation

struct Event {
    var id: String
    var name: String
    var description: String
    var location: String
    var time: NSDate
    var hostID: String
    var onlineStream: String?
    var joinAmount: Int
    var tag: [String]
    var discussionID: String
    var thumbnailURL: String?
    
    init (id: String, name: String, description: String, location: String, time: NSDate, hostID: String, onlineStream: String?, joinAmount: Int, tag: [String], discussionID: String, thumbnailURL: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.location = location
        self.time = time
        self.hostID = hostID
        self.onlineStream = onlineStream
        self.joinAmount = joinAmount
        self.thumbnailURL = thumbnailURL
        self.discussionID = discussionID
        self.tag = tag
    }
    
    init? (eventID: String, eventInfo: [String: AnyObject]) {
        guard let location = eventInfo["location"] as? String,
             description = eventInfo["description"] as? String,
             name = eventInfo["name"] as? String,
             time = eventInfo["time_since_1970"] as? Double,
             hostID = eventInfo["hostID"] as? String,
             joinAmount = eventInfo["join_amount"] as? Int,
             discussionID = eventInfo["discussionID"] as? String,
             tag = eventInfo["tag"] as? String
        else { return nil }
        
        self.id = eventID
        self.name = name
        self.description = description
        self.location = location
        self.time = NSDate(timeIntervalSince1970: time)
        self.hostID = hostID
        if let onlineStream = eventInfo["onlineStream"] as? String {
            self.onlineStream = onlineStream
        }
        self.joinAmount = joinAmount
        if let thumbnailURL = eventInfo["thumbnail_url"] as? String {
            self.thumbnailURL = thumbnailURL
        }
        self.discussionID = discussionID
        self.tag = tag.componentsSeparatedByString(",")
    }
}
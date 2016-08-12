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
    var onlineStream: Bool
    var joinAmount: Int
    var tag: [String]
    var discussionID: String
    var thumbnailURL: String
    
    
    init? (eventID: String, eventInfo: [String: AnyObject]) {
        guard let location = eventInfo["location"] as? String,
             description = eventInfo["description"] as? String,
             name = eventInfo["name"] as? String,
             time = eventInfo["time_since_1970"] as? Double,
             hostID = eventInfo["hostID"] as? String,
             onlineStream = eventInfo["onlineStrean"] as? Bool,
             joinAmount = eventInfo["join_amount"] as? Int,
             discussionID = eventInfo["discussionID"] as? String,
             thumbnailURL = eventInfo["thumbnail_url"] as? String,
             tag = eventInfo["tag"] as? String
        else { return nil }
        
        self.id = eventID
        self.name = name
        self.description = description
        self.location = location
        self.time = NSDate(timeIntervalSince1970: time)
        self.hostID = hostID
        self.onlineStream = onlineStream
        self.joinAmount = joinAmount
        self.thumbnailURL = thumbnailURL
        self.discussionID = discussionID
        self.tag = tag.componentsSeparatedByString(",")
    }
}
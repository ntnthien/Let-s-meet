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
    var location: String
    var time: NSDate
    var hostID: String
    var onlineStream: Bool
    var joinAmount: Int
    var tag: [String]
    var thumbnailURL: String
    
    init? (eventID: String, eventInfo: [String: AnyObject]) {
        guard let location = eventInfo["location"] as? String,
             time = eventInfo["time_since_1970"] as? Double,
             hostID = eventInfo["hostID"] as? String,
             onlineStream = eventInfo["onlineStrean"] as? Bool,
             joinAmount = eventInfo["join_amount"] as? Int,
             thumbnailURL = eventInfo["thumbnail_url"] as? String,
             tag = eventInfo["tag"] as? String
        else { return nil }
        
        self.id = eventID
        self.location = location
        self.time = NSDate(timeIntervalSince1970: time)
        self.hostID = hostID
        self.onlineStream = onlineStream
        self.joinAmount = joinAmount
        self.thumbnailURL = thumbnailURL
        self.tag = tag.componentsSeparatedByString(",")
    }
}
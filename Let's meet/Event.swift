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
    var description: String?
    var location: String?
    var time: NSTimeInterval?
    var hostID: String?
    var onlineStream: String?
    var joinAmount: Int?
    var tags: [String]?
    var discussionID: String?
    var thumbnailURL: String?
    var user: User?
    
    init (id: String, name: String, description: String, location: String, time: NSTimeInterval, hostID: String, onlineStream: String?, joinAmount: Int, tags: [String], discussionID: String, thumbnailURL: String?) {
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
        self.tags = tags
    }
    
    init? (eventID: String, eventInfo: [String: AnyObject]) {
        guard let name = eventInfo["name"] as? String else { return nil }
        
        self.id = eventID
        self.name = name
        self.hostID = eventInfo["host_id"] as? String
        self.joinAmount = eventInfo["join_amount"] as? Int
        self.thumbnailURL = eventInfo["thumbnail_url"] as? String
        self.discussionID = eventInfo["discussion_id"] as? String
        
        if let tagPairs = (eventInfo["tags"]) as? [String: String] {
            var tags = [String]()
            for (_, v) in tagPairs {
                tags.append(v)
            }
            if tags.count >= 1 {
                self.tags = tags
            }
        }
        self.onlineStream = eventInfo["online_stream"] as? String
        self.location = eventInfo["location"] as? String
        self.description = eventInfo["description"] as? String
        self.time =  eventInfo["time_since_1970"] as? NSTimeInterval

       
    }
    
    func toJSON() -> [String: AnyObject?] {
        return ["event_id": self.id, "location": self.location, "description": self.description, "name": self.name, "host_id": self.hostID, "time_since_1970": NSDate().timeIntervalSince1970, "join_amount": self.joinAmount, "discussion_id": self.discussionID, "thumbnail_url": self.thumbnailURL, "online_stream": self.onlineStream]
    }
}
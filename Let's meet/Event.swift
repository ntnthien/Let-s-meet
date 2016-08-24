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
    var address: String?
    var district: String?
    var city:String?
    var country = "Vietnam"
    var time: NSTimeInterval?
    var duration: UInt = 1
    var hostID: String?
    var onlineStream: String?
    var joinAmount: Int?
    var tags: [String]?
    var discussionID: String?
    var thumbnailURL: String?
    var user: User?
    
    init (id: String, name: String, description: String, address: String, district: String, city: String, country: String?, time: NSTimeInterval, duration: UInt, hostID: String, onlineStream: String?, joinAmount: Int, tags: [String], discussionID: String, thumbnailURL: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.address = address
        self.district = district
        self.city = city
        if let country = country {
            self.country = country
        }
        self.time = time
        self.duration = duration
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
        self.address = eventInfo["address"] as? String
        self.district = eventInfo["district"] as? String
        self.city = eventInfo["city"] as? String
        if let country = eventInfo["country"] as? String {
            self.country = country
        }
        self.description = eventInfo["description"] as? String
        self.time =  eventInfo["time_since_1970"] as? NSTimeInterval
        if let duration = eventInfo["duration"] as? UInt {
            self.duration = duration
        }
    }
    
    func toJSON() -> [String: AnyObject?] {
        return ["event_id": self.id, "address": self.address, "district": self.district, "city": self.city, "country": self.country, "description": self.description, "name": self.name, "host_id": self.hostID, "time_since_1970": NSDate().timeIntervalSince1970,"duration": 1, "join_amount": self.joinAmount, "discussion_id": self.discussionID, "thumbnail_url": self.thumbnailURL, "online_stream": self.onlineStream]
    }
    
    func getLocation() -> String? {
        if let address = address, district = district, city = city {
            return  ("\(address), \(district), \(city), \(country)")
        } else {
            return nil
        }
    }
}
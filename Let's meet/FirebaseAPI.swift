//
//  FirebaseAPI.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/13/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseAPI {
    let EVENT_KEY = "events"
    
    
    static var sharedInstance = FirebaseAPI()
    let eventsRef = FIRDatabase.database().reference().child("events")
    let discussionsRef =  FIRDatabase.database().reference().child("discussions")
    let tagsRef = FIRDatabase.database().reference().child("tags")
//    let userRef = FIRDatabase.database().reference().userRef
    
    let currentUser = FIRAuth.auth()?.currentUser
    
    
    func separateTags(tags: String, handler: () -> ()) -> [String] {
        let tags = tags.componentsSeparatedByString(",")
        return tags
    }
    
    
    func createEvent(event: Event) {
        let newEvent = eventsRef.childByAutoId()
        let newDiscussion = discussionsRef.childByAutoId()
        for tag in event.tags {
            tagsRef.child(tag).setValue(["event_id": newEvent.key])
        }
        let newDiscussionData = ["discussionID": newDiscussion.key]
        
        newEvent.setValue(event.toJSON())
        newDiscussion.setValue(newDiscussionData)
    }
    
    func getEvent(id: String, block: (FIRDataSnapshot) -> ()) {
        let eventRef = eventsRef.child(id)
        eventRef.observeSingleEventOfType(.Value, withBlock: block)
    }
    
    func getEvents(tags: [String], block: (FIRDataSnapshot) -> ()) {
        eventsRef.observeSingleEventOfType(.Value, withBlock: block)

    }
    
    func getEvents() {
        
    }
    
    func getUser(id: String) {
        
    }

}
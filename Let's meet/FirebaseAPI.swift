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
 
    static var sharedInstance = FirebaseAPI()
    var eventsRef = FIRDatabase.database().reference().child("events")
    var discussionsRef = FIRDatabase.database().reference().child("discussions")
    var tagsRef = FIRDatabase.database().reference().child("tags")
    
    let currentUser = FIRAuth.auth()?.currentUser
    
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
    
    func separateTags(tags: String) -> [String] {
        let tags = tags.componentsSeparatedByString(",")
        return tags
    }
}
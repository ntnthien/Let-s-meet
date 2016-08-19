//
//  FirebaseAPI.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/13/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFacebookAuthUI
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseStorage

class FirebaseAPI {
    private var authStateDidChangeHandle: FIRAuthStateDidChangeListenerHandle?
    
    private(set) var auth: FIRAuth? = FIRAuth.auth()
    private(set) var authUI: FIRAuthUI? = FIRAuthUI.authUI()
    
    static var sharedInstance = FirebaseAPI()
    
    // MARK: - Ref
    let eventsRef = FIRDatabase.database().reference().child("events")
    let discussionsRef =  FIRDatabase.database().reference().child("discussions")
    let tagsRef = FIRDatabase.database().reference().child("tags")
    let userRef = FIRDatabase.database().reference().child("users")
    let rootRef = FIRDatabase.database().reference()
    let currentUser = FIRAuth.auth()?.currentUser
    
    
    func separateTags(tags: String, handler: () -> ()) -> [String] {
        let tags = tags.componentsSeparatedByString(",")
        return tags
    }
    
    init() {
        let providers: [FIRAuthProviderUI] = [FIRFacebookAuthUI(appID: FACEBOOK_APP_ID)!]
        self.authUI?.signInProviders = providers
        self.authUI?.signInWithEmailHidden = true
        self.authUI?.termsOfServiceURL = kFirebaseTermsOfService
        self.authStateDidChangeHandle =
            self.auth?.addAuthStateDidChangeListener(self.authStateHandler(auth:user:))
        
    }
    
    
    // MARK: - Event
    func createEvent(event: Event) {
        let newEvent = eventsRef.childByAutoId()
        let newDiscussion = discussionsRef.childByAutoId()
        
        if let tags = event.tags {
            tags.forEach({ (tag) in
                if !tag.isEmpty {
                    tagsRef.child(tag).setValue(["event_id": newEvent.key])
                }
            })
        }
        
        discussionsRef.child(newEvent.key)
//        let newDiscussionData = ["discussion_id": newEvent.key]
//        newDiscussion.setValue(newDiscussionData)
        
        var eventData : [String:AnyObject?] = event.toJSON()
        eventData["event_id"] = newEvent.key
        eventData["host_id"] = currentUser?.uid
        eventData["discussion_id"] = newEvent.key
        //        eventData.flatMap { [$0:$1]}
        var dataEvent : [String:AnyObject] = [String:AnyObject]()
        
        eventData.forEach { (key,value) in
            if let _value = value
            {
                dataEvent[key] = _value
            }
            else {
                dataEvent[key] = nil
            }
        }
        newEvent.setValue(dataEvent)
    }
    
    func getEvent(id: String, completion: (Event?) -> ()) {
        eventsRef.child(id).observeSingleEventOfType(.Value) { (dataSnapshot: FIRDataSnapshot) in
            if let _dataSnapshot = dataSnapshot.value {
                if let event: Event = Event(eventID: id, eventInfo: ((_dataSnapshot as? [String:AnyObject]))!)! {
                    completion(event)
                }
            }
        }
    }
    
    func getEvents(block: (FIRDataSnapshot) -> ()) {
        eventsRef.observeEventType(.Value, withBlock: block)
    }
    
    func getEvents(tags: [String], block: (FIRDataSnapshot) -> ()) {
        eventsRef.observeEventType(.Value, withBlock: block)
    }
    func getEventsByTags(tags: [String], completion: (Event?)) {
        eventsRef.observeEventType(.Value) { (dataSnapshot: FIRDataSnapshot) in
            
        }
    }
    //    FirebaseAPI.sharedInstance.getEvents() {snapshot in
    //    self.items.removeAll()
    //    for child in snapshot.children {
    //    if let data = child as? FIRDataSnapshot {
    //    var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! )
    //    if let hostID = event?.hostID {
    //    FirebaseAPI.sharedInstance.getUser(hostID, block: { (snap) in
    //    event!.user = User(userInfo: (snap.value as? [String: AnyObject])!)
    //    self.items.append(event!)
    //    print(self.items)
    //    })
    //    }
    //    }
    //    }
    //    }
    
    
//    func getTags() {
//        tagsRef.observeSingleEventOfType(.Value) { (snapshot) in
//            
//        }
//        
//    }
    
    func getEvents(completion: (events: [Event?]) -> Void) -> Void {
        var _events: [Event?] = []
        eventsRef.observeEventType(.Value) { (dataSnapshot:FIRDataSnapshot) in
            for child in dataSnapshot.children {
                if let data = child as? FIRDataSnapshot {
                    
                    if var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! ) {
                        if let hostId = event.hostID {
                            self.getUser(hostId, completion: { (user) in
                                event.user = user
                                _events.append(event)
                                print (event)
                                
                            })
                        }
                    }
                }
            }
            completion(events: _events)
        }
    }
    
    
    // MARK: - User
    
    func getUser(id: String, completion: (User) -> ()) {
        userRef.child(id).observeSingleEventOfType(.Value) { (dataSnapshot:FIRDataSnapshot) in
            if let user: User = User(userInfo: (dataSnapshot.value as? [String:AnyObject])!) {
                completion(user)
            }
        }
        //        userRef.child(id).observeEventType(.Value) { (dataSnapshot : FIRDataSnapshot) in
        //            let user : User = User(userInfo: (dataSnapshot.value as? [String: AnyObject])!)!
        //            completion(user)
        //        }
    }
    
    
    
    
    func getUser(id: String, block: (FIRDataSnapshot) -> ()) {
        userRef.child(id).observeSingleEventOfType(.Value, withBlock: block)
        
        //        userRef.child(id).observeSingleEventOfType(.Value, withBlock: { snap in
        //            print(snap)
        //        })
    }
    
    func authStateHandler(auth auth: FIRAuth, user: FIRUser?) {
        if let user = user, userInfo = User(userInfo: user.providerData.first!) {
            userRef.child(user.uid).setValue(userInfo.toJSON())
            
            print("signed in")
        } else {
            print("signed out")
            
        }
    }
    
    func getUserID() -> String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
    
    func getUserInfo() -> FIRUserInfo? {
        if let userInfo = FIRAuth.auth()?.currentUser?.providerData.first {
            return userInfo
        } else {
            return nil
        }
    }
    
    func getLoginVC() -> UIViewController {
        logout()
        return self.authUI!.authViewController()
    }
    
    func logout() {
        do {
            try self.auth?.signOut()
        } catch let error {
            
            fatalError("Could not sign out: \(error)")
        }
    }
    
    func userIsLogin() -> Bool{
        return FIRAuth.auth()?.currentUser != nil
    }
    
    
    func changeFavorite(user userID: String, eventID: String) {
        let favoriteRef = userRef.child(userID).child("favorites")
        
    }
    
    func favoriteEvents(user userID: String) {
        
    }
    
    
    private func changeJoinValue(eventID: String, willJoin: Bool) {
        let userID = getUserID()
        self.eventsRef.child(eventID).child("join_amount").runTransactionBlock({
            (currentData: FIRMutableData!) in
            var value = currentData.value as? Int
            if value == nil  {
                value = 0
            }
            //            currentData.value = willJoin ? (value! + 1) : (value! - 1)
            
            if willJoin {
                self.userRef.child(userID!).child("events").child(eventID).setValue(NSDate().timeIntervalSince1970)
                currentData.value = value! + 1
            } else {
                self.userRef.child(userID!).child("events").child(eventID).removeValue()
                currentData.value = value! - 1
            }
            NSNotificationCenter.defaultCenter().postNotificationName(JOIN_VALUE_CHANGED_KEY, object: nil, userInfo: nil)
            
            return FIRTransactionResult.successWithValue(currentData)
        })
    }
    
    func changeJoinValue(event eventID: String)  {
        let userID = getUserID()
        eventsRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if snapshot.hasChild(eventID) {
                self.userRef.child(userID!).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                    if snapshot.hasChild("events") {
                        self.userRef.child(userID!).child("events").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                            if snapshot.hasChild(eventID) {
                                self.changeJoinValue(eventID, willJoin: false)
                            } else {
                                self.changeJoinValue(eventID, willJoin: true)
                                
                            }
                        }
                    } else {
                        self.changeJoinValue(eventID, willJoin: true)
                    }
                }
            }
        }
    }
    
    func getjoinValue(event eventID: String, block: (FIRDataSnapshot) -> ())  {
        self.userRef.child(getUserID()!).child("events").observeSingleEventOfType(.Value, withBlock: block)
    }
    
    func follow(user userID: String) {
        
    }
    
    func getFollower(user userID: String) {
        
    }
    
    func getFollowing(user userID: String) {
        
    }
    
    func sendMedia(picture: UIImage?, video: NSURL?, completion : (String?)-> Void) -> Void {
        print(FIRStorage.storage().reference())
        var fileUrl : String? = nil
        if let picture = picture, data = UIImageJPEGRepresentation(picture, 0.1) {
            let filePath = "\(currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
            print(filePath)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            FIRStorage.storage().reference().child(filePath).putData(data, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                print(metadata)
                
                fileUrl = metadata?.downloadURLs?[0].absoluteString
                completion(fileUrl)
            }
        } else if let video = video {
            let filePath = "\(currentUser?.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
            print(filePath)
            let data = NSData(contentsOfURL: video)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mp4"
            FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                print(metadata)
                fileUrl = metadata?.downloadURLs?[0].absoluteString
                completion(fileUrl)
                //                fileUrl = metadata?.downloadURLs![0].absoluteString
                //                let newMessage = self.messageRef.childByAutoId()
                //                let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO" ]
                //                newMessage.setValue(messageData)
            }
        }
    }
    
    func sendMedia(data: NSData?, contentType: ContentType, completion : (String?)-> Void) -> Void {
        print(FIRStorage.storage().reference())
        var fileUrl : String? = nil
        
        switch contentType {
        case .Photo:
            if let _data = data {
                let filePath = "\(currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
                print(filePath)
                let metadata = FIRStorageMetadata()
                metadata.contentType = ContentType.Photo.rawValue
                FIRStorage.storage().reference().child(filePath).putData(_data, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print(metadata)
                    
                    fileUrl = metadata?.downloadURLs?[0].absoluteString
                    completion(fileUrl)
                }
            }
            
        case .Video :
            
            if let _data = data {
                let filePath = "\(currentUser?.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
                print(filePath)
                //                        let data = NSData(contentsOfURL: video)
                let metadata = FIRStorageMetadata()
                metadata.contentType = ContentType.Video.rawValue
                FIRStorage.storage().reference().child(filePath).putData(_data, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print(metadata)
                    fileUrl = metadata?.downloadURLs?[0].absoluteString
                    completion(fileUrl)
                    //                fileUrl = metadata?.downloadURLs![0].absoluteString
                    //                let newMessage = self.messageRef.childByAutoId()
                    //                let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO" ]
                    //                newMessage.setValue(messageData)
                }
            }
            break
        case .File :
            break
        default:
            break
        }
        
    }
    
    // MARK: - Discussions
    
    func getDiscussions(event_id: String, completionHandler: ([Discussion?] -> Void)) {
        discussionsRef.child(event_id).observeEventType(.Value) { (dataSnapshot:
            FIRDataSnapshot) in
            var discussions: [Discussion?] = []
            for child in dataSnapshot.children {
                if let data = child as? FIRDataSnapshot {
                    if let discussion = Discussion(discussion_id: data.key, discussionInfo: (data.value as? [String: AnyObject])!) {
                        discussions.append(discussion)
                    }
                }
            }
            completionHandler(discussions)
        }
    }
    
    func createDiscussion(event_id: String, discussion: Discussion) {
        let newDiscussion = discussionsRef.child(event_id).childByAutoId()
        var discussionData: [String: AnyObject?] = discussion.toJSON()
        discussionData["discussion_id"] = newDiscussion.key
        
        var dataEvent : [String:AnyObject] = [String:AnyObject]()
        
        discussionData.forEach { (key,value) in
            if let _value = value
            {
                dataEvent[key] = _value
            }
            else {
                dataEvent[key] = nil
            }
        }
        newDiscussion.setValue(dataEvent)
    }
}
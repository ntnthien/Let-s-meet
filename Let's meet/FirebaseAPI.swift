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
import GeoFire

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
    let geofireRef = FIRDatabase.database().reference().child("locations")
    let geoFire: GeoFire!
    
    let rootRef = FIRDatabase.database().reference()
    
    let currentUser = FIRAuth.auth()?.currentUser
    
    
    func separateTags(tags: String, handler: () -> ()) -> [String] {
        let tags = tags.componentsSeparatedByString(",")
        return tags
    }
    
    private init() {
        geoFire = GeoFire(firebaseRef: geofireRef)
        let providers: [FIRAuthProviderUI] = [FIRFacebookAuthUI(appID: FACEBOOK_APP_ID)!]
        self.authUI?.signInProviders = providers
        self.authUI?.signInWithEmailHidden = true
        self.authUI?.termsOfServiceURL = kFirebaseTermsOfService
        self.authStateDidChangeHandle =
            self.auth?.addAuthStateDidChangeListener(self.authStateHandler(auth:user:))
        
    }
    
    
    // MARK: - Event
    func createEvent(event: Event, tagString: String, successHandler: (String) -> Void,
                     failureHandler: (NSError) -> Void) {
        let newEvent = eventsRef.childByAutoId()
        
        
        discussionsRef.child(newEvent.key)
        
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
        newEvent.setValue(dataEvent) { (error, databaseReference) in
            if error != nil {
                print(error.debugDescription)
                failureHandler(error!)
                return
            }
            let tags = tagString.removeWhitespaces().componentsSeparatedByString(",")
            var tagsDict = [String: String]()
            tags.forEach({ (tag) in
                if !tag.isEmpty {
                    self.tagsRef.child(tag).setValue(["event_id": newEvent.key])
                    tagsDict[tag] = tag
                }
            })
            newEvent.child("tags").setValue(tagsDict)
            
            if let address = event.address, district = event.district, city = event.city {
                let encodedAddress = "\(address), \(district), \(city), \(event.country)"
                let location = Geocoder.getLatLngForAddress(encodedAddress)
                
                self.geoFire.setLocation(location, forKey: newEvent.key) { (error) in
                    if (error != nil) {
                        print("An error occured: \(error)")
                    } else {
                        print("Saved location successfully!")
                    }
                }
            }
            successHandler(databaseReference.key)
        }
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
    
    func getEventsByTags(tags: [String], completion: (events: [Event?]) -> Void) -> Void {
        var _events: [Event?] = []
        eventsRef.queryOrderedByChild("time_since_1970").observeEventType(.Value) { (dataSnapshot:FIRDataSnapshot) in
            for child in dataSnapshot.children {
                if let data = child as? FIRDataSnapshot {
                    
                    if var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! ) {
                        if let hostId = event.hostID {
                            self.getUser(hostId,completion: { (user) in
                                event.user = user
                                _events.append(event)
                                //            completion(events: _events)
                                if _events.count == Int(dataSnapshot.childrenCount) {
                                    completion(events: _events)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func getEvents(completion: (events: [Event?]) -> Void) -> Void {
        
        var _events: [Event?] = []
        eventsRef.queryOrderedByChild("time_since_1970").observeEventType(.Value) { (dataSnapshot:FIRDataSnapshot) in
            for child in dataSnapshot.children {
                if let data = child as? FIRDataSnapshot {
                    
                    if var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! ) {
                        if let hostId = event.hostID {
                            self.getUser(hostId,completion: { (user) in
                                event.user = user
                                _events.append(event)
                                //            completion(events: _events)
                                let encodedAddress = ("\(event.address), \(event.district), \(event.city), \(event.country)").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                                let location = Geocoder.getLatLngForAddress(encodedAddress!)
                                
                                self.geoFire.setLocation(location, forKey: data.key) { (error) in
                                    if (error != nil) {
                                        print("An error occured: \(error)")
                                    } else {
                                        print("Saved location successfully!")
                                    }
                                }
                                if _events.count == Int(dataSnapshot.childrenCount) {
                                    
                                    
                                    completion(events: _events)
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func getEvents(orderBy: String, completion: (events: [Event?]) -> Void) -> Void {
        
        var _events: [Event?] = []
        eventsRef.queryOrderedByChild(orderBy).observeEventType(.Value) { (dataSnapshot:FIRDataSnapshot) in
            for child in dataSnapshot.children {
                if let data = child as? FIRDataSnapshot {
                    
                    if var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! ) {
                        if let hostId = event.hostID {
                            self.getUser(hostId,completion: { (user) in
                                event.user = user
                                _events.append(event)
                                /*
                                if let address = event.address, district = event.district, city = event.city {
                                    let encodedAddress = "\(address), \(district), \(city), \(event.country)"
                                    let location = Geocoder.getLatLngForAddress(encodedAddress)
                                    
                                    self.geoFire.setLocation(location, forKey: event.id) { (error) in
                                        if (error != nil) {
                                            print("An error occured: \(error)")
                                        } else {
                                            print("Saved location successfully!")
                                        }
                                    }
                                }
                                 */
                                //            completion(events: _events)
                                if _events.count == Int(dataSnapshot.childrenCount) {
                                    completion(events: _events)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    func getNearByEvents(location: CLLocation, radius: Double, block: GFQueryResultBlock) {
        let geoFire = GeoFire(firebaseRef: rootRef.child("locations"))
        let query = geoFire.queryAtLocation(location, withRadius: radius)
        query.observeEventType(.KeyEntered, withBlock: block)
       // query.observeEventType(.KeyEntered, withBlock: {
    //        (key: String!, location: CLLocation!) in
     //       print("+ + + + Key '\(key)' entered the search area and is at location '\(location)'")
           
     //   })
//    func getNearByEvents(center: CLLocation, radius: Double, block: GFQueryResultBlock) {
//        
//        var circleQuery = geoFire.queryAtLocation(center, withRadius: radius)
//        // Query location by region
//        let span = MKCoordinateSpanMake(0.001, 0.001)
//        let region = MKCoordinateRegionMake(center.coordinate, span)
//        var regionQuery = geoFire.queryWithRegion(region)
//        regionQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
//            print("Key '\(key)' entered the search area and is at location '\(location)'")
//        })
//        //
//        //        print("getNearByEvents: \(location)")
//        //        circleQuery.observeEventType(.KeyEntered, withBlock: {
//        //            (key: String!, location: CLLocation!) in
//        //            print("+ + + + Key '\(key)' entered the search area and is at location '\(location)'")
//        //        })
    }
    
    
    func getJoinedEvents(completion: (events: [Event?]) -> Void) -> Void {
        var _events: [Event?] = []
        userRef.child(getUserID()!).child("events").child("joined").queryOrderedByValue().observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot {
                    self.eventsRef.child(snap.key).observeSingleEventOfType(.Value) { (dataSnapshot: FIRDataSnapshot) in
                        if let _dataSnapshot = dataSnapshot.value {
                            if var event: Event = Event(eventID: snap.key, eventInfo: ((_dataSnapshot as? [String:AnyObject]))!)! {
                                if let hostId = event.hostID {
                                    self.getUser(hostId,completion: { (user) in
                                        event.user = user
                                        _events.append(event)
                                        //            completion(events: _events)
                                        if _events.count == Int(snapshot.childrenCount) {
                                            completion(events: _events)
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getSubcribedEvents(action: String, completion: (events: [Event?]) -> Void) -> Void {
        var _events: [Event?] = []
        userRef.child(getUserID()!).child("events").child(action).queryOrderedByValue().observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot {
                    self.eventsRef.child(snap.key).observeSingleEventOfType(.Value) { (dataSnapshot: FIRDataSnapshot) in
                        if let _dataSnapshot = dataSnapshot.value {
                            if var event: Event = Event(eventID: snap.key, eventInfo: ((_dataSnapshot as? [String:AnyObject]))!)! {
                                if let hostId = event.hostID {
                                    self.getUser(hostId,completion: { (user) in
                                        event.user = user
                                        _events.append(event)
                                        //            completion(events: _events)
                                        if _events.count == Int(snapshot.childrenCount) {
                                            completion(events: _events)
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getWishedEvents(action: String, completion: (events: [Event?]) -> Void) -> Void {
        var _events: [Event?] = []
        userRef.child(getUserID()!).child("events").child(action).queryOrderedByValue().observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot {
                    self.eventsRef.child(snap.key).observeSingleEventOfType(.Value) { (dataSnapshot: FIRDataSnapshot) in
                        if let _dataSnapshot = dataSnapshot.value {
                            if var event: Event = Event(eventID: snap.key, eventInfo: ((_dataSnapshot as? [String:AnyObject]))!)! {
                                if let hostId = event.hostID {
                                    self.getUser(hostId,completion: { (user) in
                                        event.user = user
                                        _events.append(event)
                                        //            completion(events: _events)
                                        if _events.count == Int(snapshot.childrenCount) {
                                            completion(events: _events)
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - User
    
    func getUser(id: String , completion: (User) -> ()) {
        
        userRef.child(id).observeSingleEventOfType(.Value) { (dataSnapshot:FIRDataSnapshot) in
            if let user: User = User(userInfo: (dataSnapshot.value as? [String:AnyObject])!) {
                completion(user)
            }
        }
    }
    
    private func getUser(id: String, block: (FIRDataSnapshot) -> ()) {
        userRef.child(id).observeSingleEventOfType(.Value, withBlock: block)
        
        //        userRef.child(id).observeSingleEventOfType(.Value, withBlock: { snap in
        //            print(snap)
        //        })
    }
    
    private func authStateHandler(auth auth: FIRAuth, user: FIRUser?) {
        if let user = user, userInfo = getUserInfo() {
            //            userRef.child(user.uid).setValue(userInfo.toJSON())
            userRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                if !snapshot.hasChild(user.uid) {
                    self.userRef.child(user.uid).setValue(userInfo.toJSON())
                }
            }
            
            
            print("signed in")
        } else {
            print("signed out")
            
        }
    }
    
    func getUserID() -> String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
    
    func getUserInfo() -> User? {
        if let userInfo = FIRAuth.auth()?.currentUser?.providerData.first {
            
            return User(uid: userInfo.uid, displayName: userInfo.displayName == nil ? "Unknow" : userInfo.displayName!, email: userInfo.email == nil ? "Unknow" : userInfo.email!, photoURL: userInfo.photoURL?.absoluteString == nil ? "Unknow" : userInfo.photoURL!.absoluteString, providerID: userInfo.providerID)
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
    
    func userIsLogin() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
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
                self.userRef.child(userID!).child("events").child("joined").child(eventID).setValue(NSDate().timeIntervalSince1970)
                currentData.value = value! + 1
            } else {
                self.userRef.child(userID!).child("events").child("joined").child(eventID).removeValue()
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
                        self.userRef.child(userID!).child("events").child("joined").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
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
        self.userRef.child(getUserID()!).child("events").child("joined").observeSingleEventOfType(.Value, withBlock: block)
    }
    
    func changeWishValue(event eventID: String)  {
        let userID = getUserID()
        eventsRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            if snapshot.hasChild(eventID) {
                self.userRef.child(userID!).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                    if snapshot.hasChild("events") {
                        self.userRef.child(userID!).child("events").child("wished").observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                            if snapshot.hasChild(eventID) {
                                self.userRef.child(userID!).child("events").child("wished").child(eventID).removeValue()
                            } else {
                                self.userRef.child(userID!).child("events").child("wished").child(eventID).setValue(NSDate().timeIntervalSince1970)
                                
                            }
                        }
                    } else {
                        self.userRef.child(userID!).child("events").child("wished").child(eventID).setValue(NSDate().timeIntervalSince1970)
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(WISH_VALUE_CHANGED_KEY, object: nil, userInfo: nil)
                }
            }
        }
    }
    
    func getWishValue(event eventID: String, block: (FIRDataSnapshot) -> ())  {
        self.userRef.child(getUserID()!).child("events").child("wished").observeSingleEventOfType(.Value, withBlock: block)
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
                    if let dataValue = data.value as? [String: AnyObject] {
                        if let discussion = Discussion(discussion_id: data.key, discussionInfo: dataValue) {
                            discussions.append(discussion)
                        }
                    }
                }
            }
            completionHandler(discussions)
        }
    }
    
    func getTags () {
        //        var tags = []
        tagsRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            for child in snap.children {
                
                if let snapshot = child as? FIRDataSnapshot {
                    print (snapshot.key)
                }
            }
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
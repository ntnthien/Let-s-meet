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
        
        let newDiscussionData = ["discussion_id": newDiscussion.key]
        newDiscussion.setValue(newDiscussionData)
        
        var eventData : [String:AnyObject?] = event.toJSON()
        eventData["event_id"] = newEvent.key
        eventData["host_id"] = currentUser?.uid
        eventData["discussion_id"] = newDiscussion.key
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
                let event: Event = Event(eventID: id, eventInfo: ((_dataSnapshot as? [String:AnyObject]))!)!
                completion(event)
            }
        }
    }
    
    func getEvents(tags: [String], block: (FIRDataSnapshot) -> ()) {
        eventsRef.observeEventType(.Value, withBlock: block)
        
    }
    
    func getEvents(block: (FIRDataSnapshot) -> ()) {
        eventsRef.observeEventType(.Value, withBlock: block)
    }
    
    
    // MARK: - User
    
//    func getUser(id: String, completion: (User?) -> ()) {
//        
//        userRef.child(id).observeEventType(.Value) { (dataSnapshot : FIRDataSnapshot) in
//            let user : User = User(userInfo: (dataSnapshot.value as? [String: AnyObject])!)!
//            completion(user)
//        }
//        //        userRef.child(id).observeSingleEventOfType(.Value, withBlock: block)
//        
//        //        userRef.child(id).observeSingleEventOfType(.Value, withBlock: { snap in
//        //            print(snap)
//        //        })
//    }
    
    
    
    
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
    
    func sendMedia(data: NSData?, mediaType: MediaType, completion : (String?)-> Void) -> Void {
        print(FIRStorage.storage().reference())
        var fileUrl : String? = nil
        
        switch mediaType {
        case .Image:
            if let _data = data {
                let filePath = "\(currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
                print(filePath)
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpg"
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
                metadata.contentType = "video/mp4"
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
        }
        
    }
    
}
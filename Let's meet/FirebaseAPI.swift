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
    
    
    // MARK: - User
    func getUser(id: String, block: (FIRDataSnapshot) -> ()) {
        userRef.observeSingleEventOfType(.Value, withBlock: block)
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
        return self.authUI!.authViewController()
    }
    
    func logout() {
        do {
            try self.auth?.signOut()
        } catch let error {
            
            fatalError("Could not sign out: \(error)")
        }
    }
}
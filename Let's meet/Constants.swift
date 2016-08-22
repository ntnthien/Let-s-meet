//
//  Constants.swift
//  Lego
//
//  Created by Do Nguyen on 7/28/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Screen constants
let SCREEN_SIZE = UIScreen.mainScreen().bounds.size
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let NAV_BAR_FONT = "Avenir-Light"
let MAIN_FONT = "Avenir-Next"

// MARK: - Colors
let MAIN_COLOR = UIColor(red: 55/255.0, green: 163/255.0, blue: 226/255.0, alpha: 1.0)
let SECONDARY_COLOR = UIColor(red: 39/255.0, green: 179/255.0, blue: 236/255.0, alpha: 1.0)
let BORDER_COLOR = UIColor.darkGrayColor()
let RED_COLOR = UIColor(red: 201/255.0, green: 63/255.0, blue: 69/255.0, alpha: 1.0)

let NAV_COLOR = UIColor(red: 55/255.0, green: 163/255.0, blue: 226/255.0, alpha: 1.0)


// MARK: - API
let GOOGLE_API_KEY = "AIzaSyCqbPtzws6qpHd7V_JE7lNNZuLh3j6cejk"
let kGoogleAppClientID = (FIRApp.defaultApp()?.options.clientID)!
let FACEBOOK_APP_ID     = "290508221310489"
let kFirebaseTermsOfService = NSURL(string: "https://firebase.google.com/terms/")!
let EVENT_KEY = "events"


// MARK: - Storyboard IDs
let MORE_VC_ID = "MoreViewController"
let PROFILE_VC_ID = "profileVC"

// MARK: - NOTFICATION KEYS
let JOIN_VALUE_CHANGED_KEY = "kJoinValueDidChangeNotification"
let WISH_VALUE_CHANGED_KEY = "kWishValueDidChangeNotification"


// MARK: - ProductDetailsViewController constants
let SHARE_WITH = "Share with"
let TWITTER = "Twitter"
let TWITTER_UNAVAILABLE = "Twitter unavailable"
let TWITTER_ERROR_MSG = "Be sure to go to Settings > Twitter to set up you Twitter account"
let FACEBOOK = "Facebook"
let FACEBOOK_UNAVAILABLE = "Facebook unavailable"
let FACEBOOK_ERROR_MSG = "Be sure to go to Settings > Facebook to set up you Facebook account"
let CANCEL = "Cancel"

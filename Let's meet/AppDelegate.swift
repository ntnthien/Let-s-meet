//
//  AppDelegate.swift
//  Let's meet
//
//  Created by Do Nguyen on 8/2/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Firebase
import Firebase
import FirebaseAuthUI
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    override init() {
        super.init()
        FIRApp.configure()
        // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Custom navigation bar
        customNavigationBar()
        UITabBar.appearance().tintColor = NAV_COLOR
        // Facebook delegate
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Firebase configure
        // Google map configure
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        return true
    }
    
    //    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    //        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    //    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String?
        if FIRAuthUI.authUI()?.handleOpenURL(url, sourceApplication: sourceApplication ?? "") ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func customNavigationBar() {
        
        // Customize Navigation Bar
        UINavigationBar.appearance().barTintColor = NAV_COLOR
        UINavigationBar.appearance().setBackgroundImage(UIImage(),forBarPosition: .Any, barMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        
        if let barFont = UIFont(name: NAV_BAR_FONT, size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: barFont]
        }
    }
    
    func changeRootView(vc: UIViewController) {
        if let window = self.window {
            window.rootViewController = vc
        }
    }
    func changeAppView(vc: UIViewController) {
        if let window = self.window {
            if let navi = window.rootViewController as? UINavigationController {
                navi.setViewControllers([vc], animated: false)
            }
        }
    }
    
    // MARK: - Local notification
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print(notificationSettings.types.rawValue)

    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Do something serious in a real app.
        print("Received Local Notification:")
        print(notification.alertBody)
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        completionHandler()
    }

}


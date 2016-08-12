//
//  LocalNotificationHelper.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation
import UIKit

class LocalNotificationHelper {
    
    func setupNotificationSettings() {
        
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        //If its value equals to None, meaning that no notification types have been set
        if (notificationSettings.types == UIUserNotificationType.None){
            
            // Specify the notification types.
            var notificationTypes = UIUserNotificationType.Alert.union(.Sound)
            // Specify the notification actions.
            var justInformAction = UIMutableUserNotificationAction()
            justInformAction.identifier = "justInform"
            justInformAction.title = "OK, got it"
            justInformAction.activationMode = UIUserNotificationActivationMode.Background
            justInformAction.destructive = false
            justInformAction.authenticationRequired = false
            
            var modifyListAction = UIMutableUserNotificationAction()
            modifyListAction.identifier = "editList"
            modifyListAction.title = "Edit list"
            modifyListAction.activationMode = UIUserNotificationActivationMode.Foreground
            modifyListAction.destructive = false
            modifyListAction.authenticationRequired = true
            
            var trashAction = UIMutableUserNotificationAction()
            trashAction.identifier = "trashAction"
            trashAction.title = "Delete list"
            trashAction.activationMode = UIUserNotificationActivationMode.Background
            trashAction.destructive = true
            trashAction.authenticationRequired = true
            
            let actionsArray = NSArray(objects: justInformAction, modifyListAction, trashAction)
            let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
            
            // Specify the category related to the above actions.
            var shoppingListReminderCategory = UIMutableUserNotificationCategory()
            shoppingListReminderCategory.identifier = "shoppingListReminderCategory"
            shoppingListReminderCategory.setActions(actionsArray as! [UIUserNotificationAction], forContext: .Default)
            shoppingListReminderCategory.setActions(actionsArrayMinimal as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
            
            let categoriesForSettings = NSSet(objects: shoppingListReminderCategory)
            
            let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as! Set<UIUserNotificationCategory>)
            //The first time the above code will work, it will create a new record for our application in the Settings app.
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        }
        
        
    }
    
    func setActions(_ actions: [AnyObject]!, forContext context: UIUserNotificationActionContext) {
        
    }
    func scheduleLocalNotification() {
        var localNotification = UILocalNotification()
        localNotification.fireDate = fixNotificationDate(NSDate())
        localNotification.alertBody = "Hey, you must go shopping, remember?"
        localNotification.alertAction = "View List"
        localNotification.category = "shoppingListReminderCategory"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        
        var dateComponets: NSDateComponents = NSCalendar.currentCalendar().components((NSCalendarUnit.Day.union(.Month).union(.Year).union(.Hour).union(.Minute)), fromDate: dateToFix)
        
        dateComponets.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponets)
        
        return fixedDate
    }
}

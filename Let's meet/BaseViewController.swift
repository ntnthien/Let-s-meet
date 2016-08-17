//
//  BaseViewController.swift
//  Lego
//
//  Created by Do Nguyen on 7/28/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func separateTags(tags: String) -> [String] {
        let tags = tags.componentsSeparatedByString(",")
        return tags
    }
    
    func switchToViewController(identifierVC: SBIdentifier.RawValue) {
        // switch view by betting navigation controller as root view controller
        // Create app view
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier(identifierVC) {
            // From mainstoryboard intantiate a navigation controller
            let naviVC = self.storyboard?.instantiateViewControllerWithIdentifier(SBIdentifier.NavigationController.rawValue) as! UINavigationController
            // Get the app delegate
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootView(naviVC)
            appDelegate.changeAppView(vc)
            self.beginAppearanceTransition(true, animated: true)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

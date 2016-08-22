//
//  LoginViewController.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Facebook login
//        initFacebookButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // If you haven't set up your authentications correctly these buttons
        // will still appear in the UI, but they'll crash the app when tapped.
        
        if isFirstLoad || FirebaseAPI.sharedInstance.userIsLogin() == false {
            
            let controller = FirebaseAPI.sharedInstance.getLoginVC()
            self.presentViewController(controller, animated: true, completion: nil)
            isFirstLoad = false
        } else {
            navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func loginButtonTouched(sender: AnyObject) {
        let controller = FirebaseAPI.sharedInstance.getLoginVC()
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        FirebaseAPI.sharedInstance.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static func fromStoryboard(storyboard: UIStoryboard = AppDelegate.mainStoryboard) -> LoginViewController {
        return storyboard.instantiateViewControllerWithIdentifier("AuthViewController") as! LoginViewController
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


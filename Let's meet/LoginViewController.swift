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
    
    let fbButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Facebook login
        initFacebookButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

// MARK: FBLogin
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func initFacebookButton() {
        fbButton.delegate = self
        fbButton.loginBehavior = FBSDKLoginBehavior.Browser
        fbButton.readPermissions = ["public_profile","user_about_me","email", "user_videos"]
        fbButton.publishPermissions = ["publish_actions"]
        fbButton.center = self.view.center
        self.view.addSubview(fbButton)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            fetchProfile()
        }
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        guard error == nil else {
            return
        }
        guard !result.isCancelled else {
            return
        }
        if FBSDKAccessToken.currentAccessToken() != nil{
            fetchProfile()
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        User.currentUser = nil
    }
    
    func fetchProfile() {
        
        let parameters = ["fields": "email, gender, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) in
            if error != nil {
                print(error)
            } else {
                User.currentUser = User(dictionary: result as! NSDictionary)
                let profileVC = self.storyboard!.instantiateViewControllerWithIdentifier("profileVC") as! ProfileViewController
                self.navigationController?.pushViewController(profileVC, animated: false)
            }
        }
    }
}



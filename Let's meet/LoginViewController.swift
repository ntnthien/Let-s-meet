//
//  LoginViewController.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: BaseViewController {
//    var loginSucessIdentifier = "showHomeVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func loginButtonTouched(sender: AnyObject) {
        let controller = serviceInstance.getLoginVC()
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        serviceInstance.logout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static func fromStoryboard(storyboard: UIStoryboard = AppDelegate.mainStoryboard) -> LoginViewController {
        return storyboard.instantiateViewControllerWithIdentifier("AuthViewController") as! LoginViewController
    }
    
    
    
    @IBAction func fbButtonTapped(sender: UIButton) {
        let facebookReadPermissions = ["email", "public_profile", "user_photos",  "user_videos"]
        let facebookPublishPermissions = ["publish_actions"]
        FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult?, error:NSError?) -> Void in
            if error != nil {
                // Process error
                FBSDKLoginManager().logOut()
                self.showError("Error Logging into Facebook", message: error!.localizedDescription)
            } else if result!.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
            }  else {
                
                FBSDKLoginManager().logInWithPublishPermissions(facebookPublishPermissions, fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult?, error:NSError?) -> Void in
                    if error != nil {
                        // Process error
                        FBSDKLoginManager().logOut()
                        self.showError("Error Logging into Facebook", message: error!.localizedDescription)
                    }
                    else if result!.isCancelled {
                        // Handle cancellations
                        FBSDKLoginManager().logOut()
                    }
                    else {
//                        // If you ask for multiple permissions at once, you
//                        // should check if specific permissions missing
//                        if result.grantedPermissions.contains("publish_actions") {
//                            // Do work
//                            login.logInWithReadPermissions(["user_likes", "user_birthday"], handler: {(result, error) in
//                                if error != nil {
//                                    // Process error
//                                }
//                                else if result.isCancelled {
//                                    // Handle cancellations
//                                }
//                                else {
//                                    // If you ask for multiple permissions at once, you
//                                    // should check if specific permissions missing
//                                    if result.grantedPermissions.contains("user_birthday") {
//                                        // Do work
//                                        print("Permission  2: \(result.grantedPermissions)")
//                                    }
//                                }
//                                
//                            })
//                        }
                        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                            if error != nil {
                                self.showError("Error Logging into Facebook", message: error!.localizedDescription)
                            } else {
                                let request = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "id, first_name, last_name, email, age_range, gender, verified, timezone, picture"])
                                request.startWithCompletionHandler {
                                    (connection, result, error) in
                                    if error != nil {
                                        print (error)
                                    } else if let userData = result as? [String : AnyObject] {
                                        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
                                        let name = "\(userData["first_name"] as! String) \(userData["last_name"] as! String)"
                                        let userInfo = ["name": name, "email": userData["email"] as! String,
                                            "photo_url": (userData["picture"]!["data"] as! [String: AnyObject])["url"] as! String, "uid": userData["id"] as! String, "provider_id": "facebook.com"]
                                        
                                        
                                        self.createFirebaseUser(userID, user: userInfo)
                                        self.navigationController?.popToRootViewControllerAnimated(true)
                                    }
                                }
                            }
                        }

                    }
                    
                })
                
            }
        })
    }
    
    func createFirebaseUser(uid: String, user: [String : AnyObject]) {
        FirebaseAPI.sharedInstance.userRef.child(uid).setValue(user)
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


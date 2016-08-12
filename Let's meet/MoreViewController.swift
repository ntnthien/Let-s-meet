//
//  MoreViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/10/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FBSDKLoginKit

class MoreViewController: BaseViewController {
    private var authStateDidChangeHandle: FIRAuthStateDidChangeListenerHandle?
    
    private(set) var auth: FIRAuth? = FIRAuth.auth()
    private(set) var authUI: FIRAuthUI? = FIRAuthUI.authUI()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // If you haven't set up your authentications correctly these buttons
        // will still appear in the UI, but they'll crash the app when tapped.
        let providers: [FIRAuthProviderUI] = [
            //      FIRGoogleAuthUI(clientID: kGoogleAppClientID)!,
            FIRFacebookAuthUI(appID: kFacebookAppID)!,
            ]
        self.authUI?.signInProviders = providers
        
        // This is listed as `TOSURL` in the objc source,
        // but it's `termsOfServiceURL` in the current pod version.
        self.authUI?.termsOfServiceURL = kFirebaseTermsOfService
        
        self.authStateDidChangeHandle =
            self.auth?.addAuthStateDidChangeListener(self.updateUI(auth:user:))
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.authStateDidChangeHandle {
            self.auth?.removeAuthStateDidChangeListener(handle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        let controller = self.authUI!.authViewController()
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
      //  LoginManager().logOut()
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let tb = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//        self.presentViewController(tb, animated: true, completion: nil)
        do {
            try self.auth?.signOut()
        } catch let error {
            // Again, fatalError is not a graceful way to handle errors.
            // This error is most likely a network error, so retrying here
            // makes sense.
            fatalError("Could not sign out: \(error)")
        }
    }
    
    func updateUI(auth auth: FIRAuth, user: FIRUser?) {
        if let user = user {
//            self.signOutButton.enabled = true
//            self.startButton.enabled = false
//            
//            self.signedInLabel.text = "Signed in"
//            self.nameLabel.text = "Name: " + (user.displayName ?? "(null)")
//            self.emailLabel.text = "Email: " + (user.email ?? "(null)")
//            self.uidLabel.text = "UID: " + user.uid
            
            print("signed in")
        } else {
//            self.signOutButton.enabled = false
//            self.startButton.enabled = true
//            
//            self.signedInLabel.text = "Not signed in"
//            self.nameLabel.text = "Name"
//            self.emailLabel.text = "Email"
//            self.uidLabel.text = "UID"
            print("signed in")

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
    
    
    static func fromStoryboard(storyboard: UIStoryboard = AppDelegate.mainStoryboard) -> MoreViewController {
        return storyboard.instantiateViewControllerWithIdentifier(MORE_VC_ID) as! MoreViewController
    }
}

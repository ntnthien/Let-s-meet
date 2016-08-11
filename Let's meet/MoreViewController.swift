//
//  MoreViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/10/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import FacebookLogin

class MoreViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        LoginManager().logOut()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tb = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//        tb.presentViewController(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        self.presentViewController(tb, animated: true, completion: nil)

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

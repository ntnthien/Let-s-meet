//
//  ProfileViewController.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
//import FacebookLogin

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = FirebaseAPI.sharedInstance.getUserInfo()
        print(user)
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutButtonTouched(sender: AnyObject) {
       FirebaseAPI.sharedInstance.logout()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView() {
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
//        
//        tableView.estimatedRowHeight = 500
//        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("profile_info") as! ProfileInfoTableViewCell
            cell.user = User.currentUser
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("logout")
            return cell!
        default:
        let cell = UITableViewCell()
        return cell
        }
    }
}

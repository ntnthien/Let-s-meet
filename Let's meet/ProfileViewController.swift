//
//  ProfileViewController.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import ReactiveKit
import ReactiveUIKit
import Haneke

class ProfileViewController: BaseViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var switchSegmentedControl: UISegmentedControl!
    
    var userID: String?
    var isFirstLoad = true

    var user: User? {
        didSet {
            if let name = user?.displayName {
                fullNameLabel.text = "\(name)"
            }
            if let url = NSURL(string: (user?.photoURL)!) {
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                //                    //make sure your image in this url does exist, otherwise unwrap in a if let check
                //                    dispatch_async(dispatch_get_main_queue(), {
                //                        self.profileImageView.image = UIImage(data: data!)
                ////                        self.profileImageView.image = UIImage(data: data!)?.createRadius(self.profileImageView.bounds.size, radius: self.profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
                //                    })
                //                }
                self.profileImageView.hnk_setImageFromURL(url)
                
                
            } else {
                profileImageView.image = UIImage(named: "user_profile")?.createRadius(profileImageView.bounds.size, radius: profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
            }
        }
    }
    var items = CollectionProperty<[Event]>([])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLabel.text = ""
        if let id = userID {
            if id != serviceInstance.getUserID()! {
                self.navigationItem.rightBarButtonItem = nil
            }
            serviceInstance.getUser(id, completion: { (user) in
                self.user = user
                self.setUpTableView()
                self.loadData()
            })
        } else
            if serviceInstance.userIsLogin() {
                user = serviceInstance.getUserInfo()
                setUpTableView()
                loadData()
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    
    func setUpUserProfile() {
        if let name = user?.displayName {
            fullNameLabel.text = "\(name)"
        }
        if let url = NSURL(string: (user?.photoURL)!) {
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //                let data = NSData(contentsOfURL: url)
            //                //make sure your image in this url does exist, otherwise unwrap in a if let check
            //                dispatch_async(dispatch_get_main_queue(), {
            //                    self.profileImageView.image = UIImage(data: data!)
            //                    //                        self.profileImageView.image = UIImage(data: data!)?.createRadius(self.profileImageView.bounds.size, radius: self.profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
            //                })
            //            }
            self.profileImageView.hnk_setImageFromURL(url)
        } else {
            profileImageView.image = UIImage(named: "user_profile")?.createRadius(profileImageView.bounds.size, radius: profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
        }
    }
    
    
    func loadData() {
        let actionString = (switchSegmentedControl.selectedSegmentIndex == 0) ? "wished" : "joined"
        serviceInstance.getSubcribedEvents(actionString) { (events: [Event?]) in
            if self.isFirstLoad {
                self.isFirstLoad = false
                
                self.loadData()
            } else  {
                self.items.removeAll()
                for event in events {
                    self.items.append(event!)
                }
            }
        }
    }
    
    
    func setUpTableView() {
        
        //        tableView.delegate = self
        tableView.rDataSource.forwardTo = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        items.bindTo(tableView) { [weak self] indexPath, dataSource, tableView in
            guard let weakSelf = self else { return UITableViewCell() }
            
            let cell = weakSelf.tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! EventHeaderTableViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configureCell(self!.items[indexPath.row])
            return cell
        }
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func switchChanged(sender: AnyObject) {
        loadData()
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
        serviceInstance.logout()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
        vc.navigationItem.leftBarButtonItem = nil
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            //            let navVC = segue.destinationViewController as! UINavigationController
            let detailVC = segue.destinationViewController as! EventDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.event = items[indexPath.row]
                detailVC.eventImage = (tableView.cellForRowAtIndexPath(indexPath) as! EventHeaderTableViewCell).thumbnailImageView.image
            }
        }
    }
}

extension ProfileViewController: ActionTableViewCellDelegate {
    func actionTableViewCell(actionTableViewCell: UITableViewCell, didTouchButton button: UIButton) {
        switch button.tag {
        case 60:
            print("Profile button touched")
            if let indexPath = (actionTableViewCell as? EventHeaderTableViewCell)?.indexPath, hostID = items[indexPath.row].hostID {
                showProfileViewController(hostID)
            }
        default:
            print("Unassigned button touched")
        }
    }
}

//
//  ProfileViewController.swift
//  Let's meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
//import FacebookLogin
import ReactiveKit
import ReactiveUIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User? {
        didSet {
            if let name = user?.displayName {
                fullNameLabel.text = "\(name)"
            }
            if let url = NSURL(string: (user?.photoURL)!) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url)
                    //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        self.profileImageView.image = UIImage(data: data!)
//                        self.profileImageView.image = UIImage(data: data!)?.createRadius(self.profileImageView.bounds.size, radius: self.profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
                    })
                }
            } else {
                profileImageView.image = UIImage(named: "user_profile")?.createRadius(profileImageView.bounds.size, radius: profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
            }
        }
    }
    var items = CollectionProperty<[Event]>([])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseAPI.sharedInstance.userIsLogin() {
            user = User(userInfo: FirebaseAPI.sharedInstance.getUserInfo()!)
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url)
                //make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    self.profileImageView.image = UIImage(data: data!)
                    //                        self.profileImageView.image = UIImage(data: data!)?.createRadius(self.profileImageView.bounds.size, radius: self.profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
                })
            }
        } else {
            profileImageView.image = UIImage(named: "user_profile")?.createRadius(profileImageView.bounds.size, radius: profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
        }
    }

    
    func loadData() {
        FirebaseAPI.sharedInstance.getEvents() {(snapshot: FIRDataSnapshot) in
            self.items.removeAll()
            for child in snapshot.children {
                if let data = child as? FIRDataSnapshot {
                    var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! )
                    if let hostID = event?.hostID {
                        FirebaseAPI.sharedInstance.getUser(hostID, block: { (snap) in
                            event!.user = User(userInfo: (snap.value as? [String: AnyObject])!)
                            self.items.append(event!)
                            print(self.items)
                        })
                    }
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
            cell.configureCell(self!.items[indexPath.row])
            return cell
        }
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
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

extension ProfileViewController: UITableViewDelegate {

}

extension ProfileViewController: ActionTableViewCellDelegate {
    func actionTableViewCell(actionTableViewCell: UITableViewCell, didTouchButton button: UIButton) {
        switch button.tag {
        case 10:
            print("Join button touched")
        case 20:
            print("Share button touched")
        case 30:
            print("Chat Button touched")
        case 60:
            print("Profile button touched")
        default:
            print("Wish button touched")
        }
    }
}

//
//  EventDetailViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Social
import Firebase
import ReactiveKit
import ReactiveUIKit

class EventDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let eventID = "-KPCQnApII4z9n_1YGBB"
    var event: Event?
    var eventImage: UIImage?
    var joinString = "Join"
    var wished = false
    var valueChanged = false
    var isStreamer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Auto sizing the tableView
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Customized the tableView
        tableView.separatorColor = UIColor.clearColor()
        if event == nil {
            serviceInstance.getEvent(eventID, completion: { (event) in
                self.event = event
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(joinValueDidChange(_:)), name: JOIN_VALUE_CHANGED_KEY, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(wishValueDidChange(_:)), name: WISH_VALUE_CHANGED_KEY, object: nil)
        
        isStreamer = (FirebaseAPI.sharedInstance.getUserID() == event?.hostID) ? true : false
        loadJoinValue()
        loadWishValue()
               // Do any additional setup after loading the view.
    }
    
    func loadJoinValue() {
        serviceInstance.getjoinValue(event: (event?.id)!) { (snapshot) in
            var change = 1
            if snapshot.hasChild((self.event?.id)!) {
                self.joinString = "Leave"
            } else {
                self.joinString = "Join"
                change = -1
            }
            
            if self.valueChanged {
                self.valueChanged = false
                self.event?.joinAmount! += change
            }
            self.tableView.reloadData()
            
        }
    }
    
    func loadWishValue() {
        serviceInstance.getWishValue(event: (event?.id)!) { (snapshot) in
            if snapshot.hasChild((self.event?.id)!) {
                self.wished = true
            } else {
                self.wished = false
            }
            
            if self.valueChanged {
                self.wished = !self.wished
//                print(self.wished)
            
            }
            self.tableView.reloadData()
            
        }
    }
    
    @objc func joinValueDidChange(notification: NSNotification) {
        valueChanged = true
        loadJoinValue()
//        self.joinString = (joinString == "Join") ? "Leave" : "Join"
//        self.tableView.reloadData()
//
    }
    
    @objc func wishValueDidChange(notification: NSNotification) {
        valueChanged = true
        loadWishValue()
        //        self.joinString = (joinString == "Join") ? "Leave" : "Join"
        //        self.tableView.reloadData()
        //
    }

    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
      MARK: - Navigation
     
      In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      Get the new view controller using segue.destinationViewController.
      Pass the selected object to the new view controller.
     }
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLiveVC" {
            
        }
    }
    
}

extension EventDetailViewController: UITableViewDataSource {
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! EventHeaderTableViewCell
            cell.selectionStyle = .None
            if let event = event, image = eventImage {
                cell.configureCell(event, image: image)
            }
//            if joinValueChanged {
//                joinValueChanged = false
//                var value = Int(cell.goingLabel.text!)!
//                value = (joinString == "Join") ? (value) : (value + 1)
//                cell.goingLabel.text = "\(value)"
//            }
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath) as! EventActionTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            cell.joinButton.setTitle(joinString, forState: .Normal)
//             joinString == "Join"
            let wishImage = wished ? "wish-fill" : "wish"
//            print(wishImage)
            let steamTitle = isStreamer ? "Start Live Stream" : "Watch Live Stream"
            cell.streamButton.backgroundColor = RED_COLOR
            cell.streamButton.setTitle(steamTitle, forState: .Normal)
            cell.wishButton.setImage(UIImage(named: wishImage), forState: .Normal)
            return cell
            
        case 2:
            let cell = (tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! EventDetailTableViewCell)
            cell.configureCell(event!)
            cell.selectionStyle = .None
            return cell
            
            
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension EventDetailViewController: ActionTableViewCellDelegate {
    func actionTableViewCell(actionTableViewCell: UITableViewCell, didTouchButton button: UIButton) {
        switch button.tag {
        case 10:
            print("Join button touched")
            serviceInstance.changeJoinValue(event: (event?.id)!)
            
        case 20:
            print("Share button touched")
            shareAction()
        case 30:
            print("Chat Button touched")
            if (self.storyboard?.instantiateViewControllerWithIdentifier("DiscussionVC")) != nil {
                self.navigationItem.backBarButtonItem?.title = " "
            }
        case 60:
            print("Profile button touched")
            showProfileViewController((event?.hostID)!)
        case 70:
            print("Stream button touched")
            if (isStreamer) {
                performSegueWithIdentifier("showLiveVC", sender: self)
            } else {
                if let uid = event?.user!.uid {
                    UIApplication.tryURL([
                        "fb://profile/\(uid)", // App
                        "http://www.facebook.com/\(uid)" // Website if app fails
                        ])
                }
            }
        default:
            print("Wish button touched")
            serviceInstance.changeWishValue(event: (event?.id)!)

        }
    }
    
    func shareAction() {
        let shareActionSheet = UIAlertController(title: nil, message: SHARE_WITH, preferredStyle: .ActionSheet)
        let twitterShareAction = UIAlertAction(title: TWITTER, style: .Default , handler: {
            (action) -> Void in
            // display the twitter composer
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetComposer.setInitialText(self.event!.name)
                //              tweetComposer.addImage(product!.images)
                self.presentViewController(tweetComposer, animated: true, completion: nil)
            } else {
                self.showAlert(TWITTER_UNAVAILABLE, msg: TWITTER_ERROR_MSG)
                
            }
        })
        
        let facebookShareAction = UIAlertAction(title: FACEBOOK, style: .Default , handler: {
            (action) -> Void in
            // display the twitter composer
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposer.setInitialText(self.event!.name)
                // tweetComposer.addImage(<#T##image: UIImage!##UIImage!#>)
                //                facebookComposer.addURL("http://google.com")
                self.presentViewController(facebookComposer, animated: true, completion: nil)
            } else {
                self.showAlert(FACEBOOK_UNAVAILABLE, msg: FACEBOOK_ERROR_MSG)
                
            }
        })
        
        let cancelShareAction = UIAlertAction(title: CANCEL, style: .Cancel, handler: nil)
        
        shareActionSheet.addAction(twitterShareAction)
        shareActionSheet.addAction(facebookShareAction)
        shareActionSheet.addAction(cancelShareAction)
        self.presentViewController(shareActionSheet, animated: true, completion: nil)
    }
}

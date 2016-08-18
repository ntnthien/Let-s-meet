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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Auto sizing the tableView
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Customized the tableView
        tableView.separatorColor = UIColor.clearColor()
        if event == nil {
            FirebaseAPI.sharedInstance.getEvent(eventID, completion: { (event) in
                self.event = event
            })
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(joinValueDidChange(_:)), name: JOIN_VALUE_CHANGED_KEY, object: nil)

        loadJoinValue()
               // Do any additional setup after loading the view.
    }
    
    func loadJoinValue() {
        FirebaseAPI.sharedInstance.getjoinValue(event: (event?.id)!) { (snapshot) in
            if snapshot.hasChild((self.event?.id)!) {
                self.joinString = "Leave"
            } else {
                self.joinString = "Join"
            }
            self.tableView.reloadData()
            
        }
    }
    
    @objc func joinValueDidChange(notification: NSNotification) {
        loadJoinValue()
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
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            cell.delegate = self
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath) as! EventActionTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            cell.joinButton.setTitle(joinString, forState: .Normal)
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
            FirebaseAPI.sharedInstance.changeJoinValue(event: (event?.id)!)
        case 20:
            print("Share button touched")
            shareAction()
        case 30:
            print("Chat Button touched")
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DiscussionVC") {
                
            }
        case 60:
            print("Profile button touched")
        default:
            print("Wish button touched")
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

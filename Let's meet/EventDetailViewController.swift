//
//  EventDetailViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let eventID = "-KPCQnApII4z9n_1YGBB"
    var event: Event?
    var eventImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Auto sizing the tableView
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Customized the tableView
        tableView.separatorColor = UIColor.clearColor()
        if event == nil {
            
            FirebaseAPI.sharedInstance.getEvent(eventID) {snapshot in
                self.event = Event(eventID: snapshot.key, eventInfo: (snapshot.value as? [String:AnyObject])!)
                FirebaseAPI.sharedInstance.getUser((self.event?.hostID)!, block: { (snap) in
                    self.event?.user = User(userInfo: (snap.value as? [String: AnyObject])!)
                    self.tableView.reloadData()
                    
                })
            }
        } else {
            tableView.reloadData()
        }
        // Do any additional setup after loading the view.
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
            return cell

        case 2:
            let cell = (tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! EventDetailTableViewCell)
            cell.selectionStyle = .None
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }
//        cell.configureCell(cell, forRowAtIndexPath: indexPath)
    }
}

extension EventDetailViewController: ActionTableViewCellDelegate {
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

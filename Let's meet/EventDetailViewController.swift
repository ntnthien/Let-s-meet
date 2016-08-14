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
    let eventID = "-KP6-ec5wBDwgSLDWd6f"
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Auto sizing the tableView
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Customized the tableView
        tableView.separatorColor = UIColor.clearColor()
        
        FirebaseAPI.sharedInstance.getEvent(eventID) {snapshot in
            self.event = Event(eventID: snapshot.key, eventInfo: (snapshot.value as? [String:AnyObject])!)
            print (self.event)
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
        var cell: UITableViewCell
        switch indexPath.row {
        case 0:
            cell = (tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! UITableViewCell)
        case 1:
            cell = (tableView.dequeueReusableCellWithIdentifier("actionCell", forIndexPath: indexPath) as! UITableViewCell)
        case 2:
            cell = (tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! UITableViewCell)
            
        default:
            cell = UITableViewCell()
        }
        cell.selectionStyle = .None
//        cell.configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        
    }
}

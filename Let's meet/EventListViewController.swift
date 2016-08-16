//
//  EventListViewController.swift
//  Lets meet
//
//  Created by admin on 8/5/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Firebase
class EventListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var events: [Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        // Do any additional setup after loading the view.

        FirebaseAPI.sharedInstance.getEvents() {snapshot in
            for child in snapshot.children {
                if let data = child as? FIRDataSnapshot {
                    var event = Event(eventID: data.key, eventInfo: (data.value as? [String:AnyObject])! )
                    if let hostID = event?.hostID {
                        FirebaseAPI.sharedInstance.getUser(hostID, block: { (snap) in
                            event!.user = User(userInfo: (snap.value as? [String: AnyObject])!)
                            self.events.append(event!)
                            print(self.events)
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("eventListCell")
        
        return cell!
    }
    
    
}









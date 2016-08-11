//
//  CreateEventViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
    }

    @IBAction func onSaveButton(sender: UIBarButtonItem) {
        print("On save event")
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

extension CreateEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTable() {
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 300
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("event_cell") as! CreateEventTableViewCell
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
}

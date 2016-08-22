//
//  EventListViewController.swift
//  Lets meet
//
//  Created by admin on 8/5/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import ReactiveKit
import ReactiveUIKit

class EventListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = CollectionProperty<[Event]>([])
    @IBOutlet weak var orderSegment: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        if (FirebaseAPI.sharedInstance.userIsLogin() == false) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
            self.showViewController(vc, sender: self)
        }
        loadData()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
//    var eventArray : [Event] = [Event]()
    func loadData() {
        let orderString =  (orderSegment.selectedSegmentIndex == 0) ? "join_amount" : "time_since_1970"
            
        FirebaseAPI.sharedInstance.getEvents(orderString) { (events: [Event?]) in
            self.items.removeAll()

            for index in (events.count - 1).stride(to: 0, by: -1) {
                self.items.append(events[index]!)
//                print(event!.joinAmount)
//                self.eventArray.append(event!)
            }
            //           let indexPath = NSIndexPath.init(forRow:  self.eventArray.count, inSection: 1)
            //            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            print(self.items.collection)
        }
    }
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.rDataSource.forwardTo = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueChange(sender: AnyObject) {
        loadData()
    }
}

extension EventListViewController: UITableViewDelegate {
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


extension EventListViewController: ActionTableViewCellDelegate {
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


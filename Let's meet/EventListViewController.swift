//
//  EventListViewController.swift
//  Lets meet
//
//  Created by admin on 8/5/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Firebase
import ReactiveKit
import ReactiveUIKit

class EventListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items = CollectionProperty<[Event]>([])
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadData()
        setUpTableView()
    }
    
    func loadData() {
        FirebaseAPI.sharedInstance.getEvents() {snapshot in
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
        
        tableView.delegate = self
        tableView.rDataSource.forwardTo = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        
        items.bindTo(tableView) { [weak self] indexPath, dataSource, tableView in
            guard let weakSelf = self else { return UITableViewCell() }
            
            let cell = weakSelf.tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! EventHeaderTableViewCell
            cell.configureCell(self!.items[indexPath.row])
            return cell
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


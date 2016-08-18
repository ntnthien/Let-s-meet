//
//  FilterViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/13/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

@objc
class Filter: NSObject {
    
    var tag: Int?
    var name: String?
    
    init(tag: Int, name: String) {
        self.tag = tag
        self.name = name
    }
}

@objc
protocol FilterViewControllerDelegate {
   optional func filterViewController(filterViewController: FilterViewController, didUpdateFilter filter: Filter)
}



class FilterViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    @IBAction func searchAcion(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}

extension FilterViewController: UITableViewDelegate {
    
    
}

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Section"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = "Cell"
        cell?.selectionStyle = .None
        return cell!
    }
    
    
    
}







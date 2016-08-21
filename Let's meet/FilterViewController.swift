//
//  FilterViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/13/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

@objc
protocol FilterViewControllerDelegate {
   optional func filterViewController(filterViewController: FilterViewController, didUpdateFilter filter: Filter)
}

class FilterViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dummyDataForCellInTagsSection = ["DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1", "DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3"]
    let dummyDataAnother = ["Something"]
    //Location
    var dummyDataLocation = ["Ho Chi Minh"]
    var dummyCollapseLocation = ["Ho Chi Minh"]
    var dummyExpandLocation = ["Ho Chi Minh", "Ha Noi", "Da Nang"]
    
    //handle page index
    var pageIndex = 1
    var pageNumber = 0
    var milestoneUpdated = 0
    let numRowPerPage = 20
    
    //handle expand section, get cell selected in tags section
    var isSeletedButtonInCellTags = false
    var isVisitedAtRowInTagSection: [Bool] = [Bool](count: 3, repeatedValue: true)
    
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
        tableView.registerNib(UINib(nibName: "FilterSectionView", bundle: nil) , forHeaderFooterViewReuseIdentifier: "FilterSectionView")
        
        //data for cell tag
        pageNumber = dummyDataForCellInTagsSection.count / numRowPerPage
        
    }

    @IBAction func searchAcion(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetAllFilter(sender: AnyObject) {
        
        let alertVC = UIAlertController(title: "Reset filters?", message: "Do you want reset filters to default", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if indexPath.section == 1 {
            
            
            if isVisitedAtRowInTagSection[indexPath.row] {
                
                //expand section
                dummyDataLocation = dummyExpandLocation
                
                //reset all boolean in all row
                for i in 0..<isVisitedAtRowInTagSection.count {
                    isVisitedAtRowInTagSection[i] = false
                }
                
            } else {
                //collapse section
                dummyDataLocation = dummyCollapseLocation
                
                //reset all boolean
                for i in 0..<isVisitedAtRowInTagSection.count {
                    isVisitedAtRowInTagSection[i] = true
                }
            }
            dummyDataLocation[0] = dummyExpandLocation[indexPath.row]
            
            //reload section
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Another"
        case 1:
            return "Location"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return dummyDataAnother.count
        case 1:
            return dummyDataLocation.count
        default:
            return numRowPerPage
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("checkCell") as! FilterCheckCell
            cell.delegate = self
            cell.selectionStyle = .None
            cell.titleCheckCell.text = dummyDataAnother[indexPath.row]
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("checkCell") as! FilterCheckCell
            cell.titleCheckCell.text = dummyDataLocation[indexPath.row]
            cell.checkButton.enabled = false
            cell.checkButton.alpha = 0
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! FilterSwitchCell
            cell.selectionStyle = .None
            cell.titleSwitchCell.text = dummyDataForCellInTagsSection[indexPath.row + milestoneUpdated]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            let headerSectionView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("FilterSectionView") as! FilterSectionView
            headerSectionView.delegate = self
            headerSectionView.customLabel.text = "Tags"
            headerSectionView.indexLabel.text = String(pageIndex)
            return headerSectionView
            
        } else {
            return nil
        }
    }
}

extension FilterViewController: FilterSectionViewDelegate {
    func filterSectionView(isNextAction: Bool, index: Int) {
        
        //get current index page
        var indexPage = index
        
        //if press next, index increase
        if isNextAction {
            indexPage = indexPage + 1
            
        } else { //index decrease
            indexPage = indexPage - 1
        }
        
        //limit value for milestone
        if indexPage <= 0 {
            pageIndex = pageNumber
            milestoneUpdated = pageNumber
            
        } else if indexPage > pageNumber {
            pageIndex = 1
            milestoneUpdated = 1
            
        } else {
            pageIndex = indexPage
            milestoneUpdated = indexPage
        }
        
        //update milestone to next milestone, milestone may be: 0, 20, 40...
        milestoneUpdated = (milestoneUpdated - 1) * numRowPerPage
        
        //animation for tags section
        if isNextAction {
            tableView.reloadSections(NSIndexSet(index: 2) , withRowAnimation: .Left)
        } else {
            tableView.reloadSections(NSIndexSet(index: 2) , withRowAnimation: .Right)
        }
    }
}


extension FilterViewController: FilterSwitchCellDelegate {
    
    func filterSwitchCell(filterSwitchCell: FilterSwitchCell, isSwitch: Bool) {
        
    }
}

extension FilterViewController: FilterCheckCellDelegate {
    func filterCheckCell(filterCheckCell: FilterCheckCell, isChecked: Bool) {
        if isChecked {
            filterCheckCell.checkButton.setImage(UIImage(named: "check"), forState: .Normal)
        } else {
            filterCheckCell.checkButton.setImage(nil, forState: .Normal)
        }
    }
}






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
    
    var delegate: FilterViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var dummyDataForCellInTagsSection = [] //["DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1", "DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3"]
    
    var tags = [String]()
    let dummyDataAnother = ["Order by date"]
    //Location
    var dummyDataLocation = ["Ho Chi Minh"]
    var dummyCollapseLocation = ["Ho Chi Minh"]
    var dummyExpandLocation = ["Ho Chi Minh", "Ha Noi", "Da Nang"]
    
    //handle page index
    var pageIndex = 1
    var pageNumber = 0
    var milestoneUpdated = 0
    let numRowPerPage = 10
    
    //handle expand section, get cell selected in tags section
    var isSeletedButtonInCellTags = false
    var isVisitedAtRowInTagSection: [Bool] = [Bool](count: 3, repeatedValue: true)
    
    var isTagEnable = true
    
    var tagsFilter: [Int: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceInstance.tagsRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
//            print(snap.childrenCount)
            for child in snap.children {
                if let snapshot = child as? FIRDataSnapshot {
                    
                    let tag = snapshot.key
                    self.tags.append(tag)
                    self.dummyDataForCellInTagsSection = self.tags
                    
                    //get page number
                    self.pageNumber = self.getPageNumber()
                    //data for cell tag
                    self.tableView.reloadData()
                    
                }
            }
        }
        
        initTableView()
    }
    
    func getPageNumber() -> Int{
        var pageNum: Double = 0
        pageNum = ceil(Double(dummyDataForCellInTagsSection.count) / Double(numRowPerPage))
        let pageNumber = Int(pageNum)
        return pageNumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "FilterSectionView", bundle: nil) , forHeaderFooterViewReuseIdentifier: "FilterSectionView")
        //get page number
        //self.pageNumber = self.getPageNumber()
    }

    @IBAction func searchAcion(sender: AnyObject) {
        
        var tagsToFilter = [String]()
        
        for (row, isSelected) in tagsFilter {
            if isSelected {
                tagsToFilter.append(tags[row])
            }
        }
        
        let userdefault = NSUserDefaults()
        if userdefault.getIsEnableForKey(kIsEnable) == true {
            let filter = Filter(tags: tagsToFilter, location: nil)
            delegate?.filterViewController!(self, didUpdateFilter: filter)
        }
        else {
            let filter = Filter(tags: tags, location: nil)
            delegate?.filterViewController!(self, didUpdateFilter: filter)
        }
        
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
            return "Date"
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
            if dummyDataForCellInTagsSection.count > 0 {
                
                if dummyDataForCellInTagsSection.count < numRowPerPage {
                    return dummyDataForCellInTagsSection.count
                    
                } else {
                    let countRowAll = dummyDataForCellInTagsSection.count
                    let offset = (countRowAll % numRowPerPage)
                    if offset != 0 {
                        if (pageNumber - pageIndex) == 0 {
                            return offset
                        } else {
                            return numRowPerPage
                        }
                    } else {
                        return numRowPerPage
                    }
                }
            } else {
                return 0
            }
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
            cell.delegate = self
            cell.selectionStyle = .None
            if dummyDataForCellInTagsSection.count > 0 {
                cell.switchButton.on = tagsFilter[indexPath.row] ?? false
                cell.titleSwitchCell.text = dummyDataForCellInTagsSection[indexPath.row + milestoneUpdated] as? String
                
                let userDefault = NSUserDefaults()
                isTagEnable = userDefault.getIsEnableForKey(kIsEnable)!
                if isTagEnable {
                    cell.switchButton.enabled = true
                    
                } else {
                    cell.switchButton.enabled = false
                }
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            let headerSectionView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("FilterSectionView") as! FilterSectionView
            headerSectionView.delegate = self
            headerSectionView.customLabel.text = "Tags"
            headerSectionView.indexLabel.text = String(pageIndex)
            let userDefault = NSUserDefaults()
            let isOn = userDefault.getIsEnableForKey(kIsEnable)
            if (isOn != nil) {
                headerSectionView.switchButton.on = isOn!
            }
            return headerSectionView
            
        } else {
            return nil
        }
    }
}

extension FilterViewController: FilterSectionViewDelegate {
    
    func filterSectionView(filterSectionView: FilterSectionView, isSwitch: Bool) {
        filterSectionView.switchButton.onTintColor = MAIN_COLOR
        let userDefault = NSUserDefaults()
        if isSwitch {
            userDefault.setIsEnableTags(true, forKey: kIsEnable)
        } else {
            userDefault.setIsEnableTags(false, forKey: kIsEnable)
        }
//        tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Fade)
        tableView.reloadData()
    }
    
    func filterSectionView(filterSectionView: FilterSectionView, isNextAction: Bool, index: Int) {
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
        
        let indexPath = tableView.indexPathForCell(filterSwitchCell)
        
        if indexPath?.section == 2 {
            tagsFilter[(indexPath?.row)!] = isSwitch
        }
        
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






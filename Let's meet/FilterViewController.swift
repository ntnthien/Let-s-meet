//
//  FilterViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/13/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

//this class for filter
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
    var isLoadedSection = false
    let dummyDataForCellInTagsSection = ["DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1","DataScreen1", "DataScreen1", "DataScreen1", "DataScreen1", "DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen2", "DataScreen2", "DataScreen2", "DataScreen2","DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3", "DataScreen3","DataScreen3", "DataScreen3"]
    //handle page index
    var pageIndex = 1
    var pageNumber = 0
    var milestoneUpdated = 0
    
    var dummyDataForCellInTag = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dummyDataForCellInTag = dummyDataForCellInTagsSection
        pageNumber = dummyDataForCellInTagsSection.count / 20
        
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Location"
        case 1:
            return "Another"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 20
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("checkCell") as! FilterCheckCell
            cell.delegate = self
            cell.selectionStyle = .None
            cell.titleCheckCell.text = "Ho Chi Minh"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("checkCell") as! FilterCheckCell
            cell.delegate = self
            cell.selectionStyle = .None
            cell.titleCheckCell.text = "Some thing"
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! FilterSwitchCell
            cell.selectionStyle = .None
            cell.titleSwitchCell.text = (dummyDataForCellInTag[indexPath.row + milestoneUpdated] as? String)!
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
        milestoneUpdated = (milestoneUpdated - 1) * 20
        
        //animation for tags section
        if isNextAction {
            tableView.reloadSections(NSIndexSet(index: 2) , withRowAnimation: .Left)
        } else {
            tableView.reloadSections(NSIndexSet(index: 2) , withRowAnimation: .Right)
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

extension FilterViewController: FilterSwitchCellDelegate {
    
    func filterSwitchCell(filterSwitchCell: FilterSwitchCell, isSwitch: Bool) {
        
    }
}






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
    
    var popViewController : DatePickerPopupViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        //        self.setRoundedBorder(5, withBorderWidth: 1, withColor: UIColor(red: 0.0, green: 122.0/2550, blue: 1.0, alpha: 1.0), forButton: showPopupBtn)
        
    }
    
    @IBAction func onSaveButton(sender: UIBarButtonItem) {
        print("On save event")
    }
    
    
    func setRoundedBorder(radius : CGFloat, withBorderWidth borderWidth: CGFloat, withColor color : UIColor, forButton button : UIButton)
    {
        let l : CALayer = button.layer
        l.masksToBounds = true
        l.cornerRadius = radius
        l.borderWidth = borderWidth
        l.borderColor = color.CGColor
    }
    func showPopUp() {
        self.popViewController = DatePickerPopupViewController(nibName: "DatePickerPopupViewController", bundle: nil)
        self.popViewController.title = "This is a popup view"
        self.popViewController.showInView(self.view, animated: true)
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
            cell.delegate = self
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
}

extension CreateEventViewController: CreateEventTableViewCellDelegate {
    func clickEditImage(createEventTVC: CreateEventTableViewCell, isCliked: Bool) {
        print("clickEditImage \(isCliked)")
    }
    
    func clickDatePicker(createEventTVC: CreateEventTableViewCell, isCliked: Bool) {
        print("clickDatePicker \(isCliked)")
        showPopUp()
    }
}

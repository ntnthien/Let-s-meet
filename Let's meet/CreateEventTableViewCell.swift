//
//  CreateEventTableViewCell.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

@objc protocol CreateEventTableViewCellDelegate {
    optional func clickDatePicker(createEventTVC: CreateEventTableViewCell, isCliked: Bool)
    optional func clickEditImage(createEventTVC: CreateEventTableViewCell, isCliked: Bool)
}
class CreateEventTableViewCell: UITableViewCell {

    @IBOutlet weak var panelImage: UIImageView!
    
    @IBOutlet weak var titleTextfield: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var availableMeetTextfield: UITextField!
    
    @IBOutlet weak var locationTextfield: UITextField!
    
    @IBOutlet weak var priceTextfield: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    
    var delegate: CreateEventTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.tintColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onEditButton(sender: UIButton) {
        print("Edit button is clicked")
        delegate.clickEditImage!(self, isCliked: true)
    }
    
    @IBAction func onDatePickerButton(sender: UIButton) {
        print("Date Picker button is clicked")
        delegate.clickDatePicker!(self, isCliked: true)
    }
    
}

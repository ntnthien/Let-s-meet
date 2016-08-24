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
    func eventInfoValidateFail(cell: CreateEventTableViewCell, msg:String)
}
class CreateEventTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var panelImage: UIImageView!
    
    @IBOutlet weak var titleTextfield: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var districtTextfield: UITextField!
    
    @IBOutlet weak var cityTextfield: UITextField!
    
    @IBOutlet weak var tagTextfield: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var delegate: CreateEventTableViewCellDelegate!
    
    //    var id: String
    //    var name: String
    //    var description: String
    //    var location: String
    //    var time: NSDate
    //    var hostID: String
    //    var onlineStream: String?
    //    var joinAmount: Int
    //    var tags: [String]
    //    var discussionID: String
    //    var thumbnailURL: String?
    
    var observerCreateEvent:String? {
        didSet {
            getEventInfo()
        }
    }
    
    
    var event: Event? {
        didSet {
            titleTextfield.text = event?.name
            timeLabel.text = event?.time?.description
            addressTextfield.text = event?.address
            districtTextfield.text = event?.district
            cityTextfield.text = event?.city
            tagTextfield.text = event?.tags?.description
            descriptionTextView.text = event?.description
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.tintColor = UIColor.whiteColor()
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1.0).CGColor
        descriptionTextView.layer.cornerRadius = 5.0
        self.selectionStyle = .None
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
    
    func getEventInfo() -> Event? {
        
        let currentDate = NSDate().timeIntervalSince1970
        var tagDictionary = [String: String]()
        for tag in tagTextfield.text!.removeWhitespaces().componentsSeparatedByString(",") {
            tagDictionary[tag] = tag
        }
        let newEventData: [String:AnyObject] = [ "event_id": " ", "address": addressTextfield.text!, "district": districtTextfield.text!, "city": cityTextfield.text!, "country": "Vietnam", "description": descriptionTextView.text , "name": titleTextfield.text!, "host_id": "", "time_since_1970": currentDate, "duration": 1, "join_amount": 0, "discussion_id": "", "tags": tagDictionary, "thumbnail_url": " ", "online_stream": ""]
        
        let event = Event(eventID: "1", eventInfo: newEventData)
        
        
        //        delegate?.eventInfoValidateFail(self, msg: "Event is not valid")
        
        return event
    }
    //    func textFieldDidEndEditing(textField: UITextField) {
    //        print("textFieldDidEndEditing")
    //    }
    //
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        print("textFieldDidBeginEditing")
    //    }
}


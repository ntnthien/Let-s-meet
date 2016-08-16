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
    
    @IBOutlet weak var availableMeetTextfield: UITextField!
    
    @IBOutlet weak var locationTextfield: UITextField!
    
    @IBOutlet weak var priceTextfield: UITextField!
    
    @IBOutlet weak var tagTextfield: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
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
            locationTextfield.text = event?.location
            availableMeetTextfield.text = event?.location
            priceTextfield.text = ""
            tagTextfield.text = event?.tags?.description
        }
    }
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
    
    func getEventInfo() -> Event? {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var currentDate = dateFormatter.stringFromDate(NSDate())
        let newEventData: [String:AnyObject] = [ "event_id": " ", "location": locationTextfield.text!, "description": " " , "name": titleTextfield.text!, "host_id": "", "time_since_1970": currentDate, "join_amount": 0, "discussion_id": "", "tags": tagTextfield.text!, "thumbnail_url": " ", "online_stream": ""]
        
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


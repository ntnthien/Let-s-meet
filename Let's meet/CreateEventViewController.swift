//
//  CreateEventViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MobileCoreServices

class CreateEventViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var popViewController : DatePickerPopupViewController!
    var event: Event!
    
    var eventsRef = FIRDatabase.database().reference().child("events")
    var discussionsRef = FIRDatabase.database().reference().child("discussions")
    var tagsRef = FIRDatabase.database().reference().child("tags")

    let currentUser = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
    }
    
    @IBAction func onSaveButton(sender: UIBarButtonItem) {
        print("On save event")
//        
//        let newEvent = eventsRef.childByAutoId()
//        let newDiscussion = discussionsRef.childByAutoId()
        let tags = "docker, firebase"
//        for tag in separateTags(tags) {
//            tagsRef.child(tag).setValue(["event_id": newEvent.key])
//        }
//        let newEventData = ["event_id": newEvent.key, "location": "12 Nguyen Trai", "description": "No description", "name": "WWDC 2016", "host_id": currentUser!.uid, "time_since_1970": "123456", "join_amount": 0, "discussion_id": newDiscussion.key, "tags": tags, "thumbnail_url": "http://www.bahiadelaluna.com/blog/wp-content/uploads/2016/04/hotel-en-oaxaca-salud.png", "online_stream": ""]
//        let newDiscussionData = ["discussion_id": newDiscussion.key]
//        
//        newEvent.setValue(newEventData)
//        newDiscussion.setValue(newDiscussionData)
        let newEventData = ["event_id": "", "location": "12 Nguyen Trai", "description": "No description", "name": "WWDC 2016", "host_id": currentUser!.uid, "time_since_1970": 123534, "join_amount": 0, "discussion_id": "", "tags": tags, "thumbnail_url": "http://www.bahiadelaluna.com/blog/wp-content/uploads/2016/04/hotel-en-oaxaca-salud.png", "online_stream": ""]
        let eventObject = Event(eventID: "", eventInfo: newEventData as! [String : AnyObject])
        FirebaseAPI.sharedInstance.createEvent(eventObject!)
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
        didPressImagePickerButton()
    }
    
    func clickDatePicker(createEventTVC: CreateEventTableViewCell, isCliked: Bool) {
        print("clickDatePicker \(isCliked)")
        showPopUp()
    }
    
//    func getMediaFrom(type: CFString){
//        let mediaPicker = UIImagePickerController()
//        mediaPicker.delegate = self
//        mediaPicker.mediaTypes = [type as String]
//        self.presentViewController(mediaPicker, animated: true, completion: nil)
//    }
    
    func didPressImagePickerButton() {
        print("didPressImagePickerButton")
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
            
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .Default) { (alert) in
//            self.getMediaFrom(kUTTypeImage)
            
        }
        
        let videoLibrary = UIAlertAction(title: "Video Library", style: .Default) { (alert) in
//            self.getMediaFrom(kUTTypeMovie)
        }
        sheet.addAction(photoLibrary)
        sheet.addAction(videoLibrary)
        sheet.addAction(cancel)
        self.presentViewController(sheet, animated: true, completion: nil)
        
        //        let imagePicker = UIImagePickerController()
        //        imagePicker.delegate = self
        //        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
}

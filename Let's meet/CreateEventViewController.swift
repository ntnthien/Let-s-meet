//
//  CreateEventViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateEventViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var popViewController : DatePickerPopupViewController!
    var event: Event!
    
    var pannelImage = UIImage()
    var cell:CreateEventTableViewCell?
    
    // Keyboard is presenting or not
    var keyboardPresenting = false
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTable()
        // add keyboard notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(willShowKeyBoard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(willHideKeyBoard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        // Tap screen
        hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
    }
    
    @IBAction func onSaveButton(sender: UIBarButtonItem) {
        print("On save event")
        var event = cell?.getEventInfo()
        print(event?.name)
        if let eventTime = popViewController?.eventTime {
            event?.time = eventTime
        }
        if let data = UIImageJPEGRepresentation(pannelImage, 0.1)
        {
            serviceInstance.sendMedia(data, contentType: ContentType.Photo) { (fileUrl) in
                event?.thumbnailURL = fileUrl
                if let event = event {
                    self.serviceInstance.createEvent(event, successHandler: { (eventKey) in
                        print(eventKey)
                        if let eventTimeInterval = event.time {
                            if let notidyTime: NSDate = NSDate(timeIntervalSince1970: eventTimeInterval) {
                                LocalNotificationHelper.sharedInstance?.scheduleNotificationWithKey(event.id, title: "Hey, the event - \(event.name) about to start. Are you get ready to go now?", message: "Open Meetup", date: notidyTime, userInfo: nil)
                            }
                        }
                        self.navigationController?.popViewControllerAnimated(true)
                        }, failureHandler: { (error) in
                            print("Event was not saved yet!")
                    })
                    
                }
            }
        }
        else {
            if let event = event {
                serviceInstance.createEvent(event, successHandler: { (eventKey) in
                    if let eventTimeInterval = event.time {
                        if let notidyTime: NSDate = NSDate(timeIntervalSince1970: eventTimeInterval) {
                            LocalNotificationHelper.sharedInstance?.scheduleNotificationWithKey(event.id, title: "Hey, the event - \(event.name) about to start. Are you get ready to go now?", message: "Open Meetup", date: notidyTime, userInfo: nil)
                        }
                    }                    }, failureHandler: { (error) in
                        print("Event was not saved yet!")
                })
            }
        }
    }
    
    // MARK: - DatePicker pop up
    func showPopUp() {
        self.popViewController = DatePickerPopupViewController(nibName: "DatePickerPopupViewController", bundle: nil)
        self.popViewController.title = "This is a popup view"
        self.popViewController.showInView(self.view, animated: true)
        self.popViewController.delegate = self
        self.view.endEditing(true)
    }
    
    // MARK: Keyboard handler
    override func handleKeyboardWillShow(duration: NSTimeInterval, keyBoardRect: CGRect) {
        self.view.addGestureRecognizer(hideKeyboardTap)
        keyBoardDetailControl(0, duration: duration, keyBoardRect: keyBoardRect)
    }
    override func handleKeyboardWillHide(duration: NSTimeInterval, keyBoardRect: CGRect) {
        self.view.removeGestureRecognizer (hideKeyboardTap)
        keyBoardDetailControl(1, duration: duration, keyBoardRect: keyBoardRect)
        
    }
    override func tapScreen() {
        print("Screen is tapped")
        if !keyboardHidden {
            self.view.endEditing(true)
        }
    }
    
    func keyBoardDetailControl(flagKeyboard: Int, duration: NSTimeInterval, keyBoardRect: CGRect) {
        
        var keyboardHeight: CGFloat = 0
        keyboardHeight = 0
        
        let tabbarHeight:CGFloat = tabBarController?.tabBar.bounds.size.height ?? 0
        
        if flagKeyboard == 0 {
            keyboardHeight = (keyBoardRect.height - tabbarHeight )
        }
        
        self.keyboardPresenting = flagKeyboard == 0
        
        UIView.animateWithDuration(duration, animations: {
            self.tableViewBottomConstraint.constant = keyboardHeight
        }) { (Bool) in
        }
    }
    
    // Remove Observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
            cell = (tableView.dequeueReusableCellWithIdentifier("event_cell") as! CreateEventTableViewCell)
            
            cell?.panelImage.image = pannelImage
            cell?.delegate = self
            return cell!
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
    
    func eventInfoValidateFail(cell: CreateEventTableViewCell, msg: String) {
        print(msg)
    }
    
    func getMediaFrom(type: CFString){
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.presentViewController(mediaPicker, animated: true, completion: nil)
    }
    
    func didPressImagePickerButton() {
        print("didPressImagePickerButton")
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction) in
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .Default) { (alert) in
            self.getMediaFrom(kUTTypeImage)
        }
        sheet.addAction(photoLibrary)
        sheet.addAction(cancel)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
}
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pannelImage = picture
        }
        // dismiss the photo
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
}

extension CreateEventViewController: DatePickerPopupViewControllerDelegate {
    func getDate(date: NSTimeInterval) {
        let formatter = NSDateFormatter()
            formatter.dateFormat = "dd'-'MM'-'yyyy' 'HH':'mm':'ss"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 7)
            let date = formatter.stringFromDate(NSDate(timeIntervalSince1970: date))
        
        
    }
}
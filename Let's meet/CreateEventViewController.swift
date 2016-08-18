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
import FirebaseStorage

class CreateEventViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var popViewController : DatePickerPopupViewController!
    var event: Event!
    
    var pannelImage = UIImage()
    var cell:CreateEventTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTable()
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
            FirebaseAPI.sharedInstance.sendMedia(data, contentType: ContentType.Photo) { (fileUrl) in
                event?.thumbnailURL = fileUrl
                if let event = event {
                    FirebaseAPI.sharedInstance.createEvent(event)
                }
            }
        }
        else {
            if let event = event {
                FirebaseAPI.sharedInstance.createEvent(event)
            }
        }
        
        
//        FirebaseAPI.sharedInstance.sendMedia(pannelImage, video: nil, completion: { (fileUrl) in
//            event?.thumbnailURL = fileUrl
//            if let event = event {
//                FirebaseAPI.sharedInstance.createEvent(event)
//            }
//        })
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

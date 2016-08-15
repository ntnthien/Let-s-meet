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
        let event = cell?.getEventInfo()
        print(event?.name)
        FirebaseAPI.sharedInstance.createEvent(event!)
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

extension CreateEventViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing")
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
    
    func eventInfoValidateFaild(cell: CreateEventTableViewCell, msg: String) {
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
        
        //        let imagePicker = UIImagePickerController()
        //        imagePicker.delegate = self
        //        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
}
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pannelImage = picture
            // add image to screen
            //            sendMedia(picture, video: nil)
        }
        // dismiss the photo
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    func sendMedia(picture: UIImage?, video: NSURL?) {
        print(FIRStorage.storage().reference())
        /*
         if let picture = picture {
         let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
         print(filePath)
         let data = UIImageJPEGRepresentation(picture, 0.1)
         let metadata = FIRStorageMetadata()
         metadata.contentType = "image/jpg"
         FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
         if error != nil {
         print(error?.localizedDescription)
         return
         }
         print(metadata)
         let fileUrl = metadata?.downloadURLs![0].absoluteString
         event.thumbnailURL = fileUrl
         }
         } else if let video = video {
         let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
         print(filePath)
         let data = NSData(contentsOfURL: video)
         let metadata = FIRStorageMetadata()
         metadata.contentType = "video/mp4"
         FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
         if error != nil {
         print(error?.localizedDescription)
         return
         }
         print(metadata)
         let fileUrl = metadata?.downloadURLs![0].absoluteString
         let newMessage = self.messageRef.childByAutoId()
         let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO" ]
         newMessage.setValue(messageData)
         }
         
         }*/
    }
}

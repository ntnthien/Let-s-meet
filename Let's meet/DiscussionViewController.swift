//
//  DiscussionViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/17/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Haneke

class DiscussionViewController: BaseViewController {
    
    
    // Các Outlet cần thiết cho view
    @IBOutlet weak var heightOfMessageView: NSLayoutConstraint!
    @IBOutlet weak var messageTextInputView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageButtonOutlet: UIButton!
    @IBOutlet weak var viewInputSendMessage: UIView!
    @IBOutlet weak var viewInputSendMessageBottomConstraint: NSLayoutConstraint!
    
    var currentUser: User?
    
    var eventID = "-KPVjTT3za3KXapXni6P"
//    var eventID = "-KPMddCnTDeaeDPFEXu2"
    var discussionID = "-KPVjTT3za3KXapXni6P"
    var discussionArray:Array<Discussion> = []
    
    // Dictionary lưu các url avatar users
    var userAvtDict = Dictionary<String,String>()
    
    //Firebase Storage Image
    var imgSelected: String?
    var imgDataSelected:NSData?
    
    var imgPickerVC: UIImagePickerController?
    
    var flagCameraTakeOrSelectPhoto = 0
    
    // Limit query last messages
    let numberOfLastMessages: UInt = 25
    // Last item ID to paging
    var lastMessageKey:String?
    
    // Các biến kiểm soát load data
    var isLoadingData                   = false
    var hasNextData                     = true
    
    // Keyboard is presenting or not
    var keyboardPresenting              = false
    
    // Data source from Firebase
    //    var messagesRef:FIRDatabaseReference!
    
    // Avatar placeholder image
    let avtPlaceHolderImg :UIImage = UIImage.imageWithColor(UIColor.lightGrayColor(), size: CGSize(width: 30, height: 30)).createRadius(CGSize(width: 30, height: 30), radius: 15, byRoundingCorners: UIRectCorner.AllCorners)
    
    // Refesh controler for chat table
    let refeshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = serviceInstance.getUserInfo()
        
        if let tabbar = self.tabBarController?.tabBar {
            let tabbarHeight = tabbar.bounds.size.height
            chatTableView.contentInset.bottom = tabbarHeight + 40
            chatTableView.scrollIndicatorInsets = chatTableView.contentInset
        }
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 400
        
        loadDiscussion()
        
        createNotificationCenter()
        // Tap screen
        hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setUpView() {
        self.navigationItem.title = "Event title"
        
        messageTextInputView.layer.borderWidth = 1
        messageTextInputView.layer.borderColor = UIColor(red: 206/255 ,green: 206/255, blue: 206/255 ,  alpha: 1 ).CGColor
        messageTextInputView.layer.cornerRadius = 5
        
        self.chatTableView.addSubview(refeshControl)
    }
    
    
    func loadDiscussion () {
        
        serviceInstance.getDiscussions(eventID) { (discussions) in
            self.discussionArray.removeAll()
            for discussion in discussions {
                self.discussionArray.append(discussion!)
            }
            self.chatTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSendMessageButton(sender: AnyObject) {
        if let discussion = getMessageInfo() {
            serviceInstance.createDiscussion(eventID, discussion: discussion)
        }
    }
    
    @IBAction func onAttachFileButton(sender: UIButton) {
        print("onAttachFileButton is clicked")
    }
    
    func getMessageInfo() -> Discussion? {
        if let message = messageTextInputView.text, currentUser = currentUser {
            self.messageTextInputView.text = nil
            
            let newMessageData: [String:AnyObject] = ["discussion_id": "1", "content_type": ContentType.Text.rawValue,"content_msg": message, "sender_id": currentUser.uid, "sender_name": currentUser.displayName, "sender_photo": currentUser.photoURL, "time": NSDate().timeIntervalSince1970]
            return Discussion(discussion_id: "1", discussionInfo: newMessageData)
        }
        return nil
    }
    
    // MARK: Keyboard handler
    
    override func handleKeyboardWillShow(duration: NSTimeInterval, keyBoardRect: CGRect) {
        self.view.addGestureRecognizer(hideKeyboardTap)
        keyBoardChatDetailControl(0, duration: duration, keyBoardRect: keyBoardRect)
    }
    override func handleKeyboardWillHide(duration: NSTimeInterval, keyBoardRect: CGRect) {
        self.view.removeGestureRecognizer (hideKeyboardTap)
        keyBoardChatDetailControl(1, duration: duration, keyBoardRect: keyBoardRect)
    }
    
    override func tapScreen() {
        print("Screen is tapped")
        if !keyboardHidden {
            self.view.endEditing(true)
        }
    }
    
    func keyBoardChatDetailControl(flagKeyboard: Int, duration: NSTimeInterval, keyBoardRect: CGRect) {
        
        var keyboardHeight: CGFloat = 0
        keyboardHeight = 0
        
        let tabbarHeight:CGFloat = tabBarController?.tabBar.bounds.size.height ?? 0
        
        if flagKeyboard == 0 {
            keyboardHeight = (keyBoardRect.height - tabbarHeight )
        }
        
        self.keyboardPresenting = flagKeyboard == 0
        
        UIView.animateWithDuration(duration, animations: {
            
            self.viewInputSendMessageBottomConstraint.constant = keyboardHeight
            
            self.messageTextInputView.superview?.layoutIfNeeded()
            
            self.chatTableView.contentInset.bottom = (flagKeyboard == 0) ? keyBoardRect.height + 40  : 40 + tabbarHeight
            
            if self.discussionArray.count == 0 { return }
            self.scrollTableViewToEnd()
            
        }) { (Bool) in
        }
    }
    
    // Remove Observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    // scroll to the end of table view
    private func scrollTableViewToEnd() {
        let rowIndex = self.discussionArray.count > 0 ? self.discussionArray.count - 1 : 0
        let lastIndexPath = NSIndexPath(forRow: rowIndex, inSection: 0)
        self.chatTableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: false)
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

extension DiscussionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Lấy message ở row index
        let message = discussionArray[indexPath.row]
        
        // Xác định cell id là của cell cho sender hay reciever
        let cellId = (message.sender_id == currentUser?.uid) ? "cellSender" : "cellReceiver"
        let cell = chatTableView.dequeueReusableCellWithIdentifier(cellId) as! ChatTableViewCell
        cell.discussion = message
        // Thiết lập màu cho bong bóng chat
        if (message.sender_id == currentUser?.uid) {
            cell.messageBubbleView.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255 , alpha: 1)
        } else {
            cell.messageBubbleView.backgroundColor = UIColor(red: 242/255, green: 120/255, blue: 5/255 , alpha: 1)
        }
        
        // Hiển thị avatar
        cell.avatarImg.image = avtPlaceHolderImg
        if let url = NSURL(string: message.sender_photo!) {
            cell.avatarImg.hnk_setImageFromURL(url)
            cell.avatarImg.layer.cornerRadius = 15.0
            cell.avatarImg.clipsToBounds = true
        }
        // Nếu message là hình ảnh
        if message.content_type == ContentType.Photo.rawValue {
            
        }
            // Nếu message là text bình thường
        else {
            let textChatCell = cell as! ChatTextTableViewCell
            textChatCell.contentMessageLabel.text       = message.content_msg
            textChatCell.contentMessageLabel.textColor  = UIColor.blueColor()
        }
        
        return cell
    }
}

//
//  DiscussionViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/17/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class DiscussionViewController: BaseViewController {
    
    
    // Các Outlet cần thiết cho view
    @IBOutlet weak var heightOfMessageView: NSLayoutConstraint!
    @IBOutlet weak var messageTextInputView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageButtonOutlet: UIButton!
    @IBOutlet weak var viewInputSendMessage: UIView!
    @IBOutlet weak var viewInputSendMessageBottomConstraint: NSLayoutConstraint!
    
    var currentuserID = "Rxup9VnrnPbpODuSK65ggUBj4w72"
    var eventID = "-KPVjTT3za3KXapXni6P"
    var discussionID = "-KPVjTT3za3KXapXni6P"
    var discussion:Array<Discussion> = []
    
    // Dictionary lưu các url avatar users
    var userAvtDict         = Dictionary<String,String>()
    
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
    let avtPlace :UIImage = UIImage.imageWithColor(UIColor.lightGrayColor(), size: CGSize(width: 30, height: 30)).createRadius(CGSize(width: 30, height: 30), radius: 15, byRoundingCorners: UIRectCorner.AllCorners)
    
    // Refesh controler for chat table
    let refeshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabbar = self.tabBarController?.tabBar {
            let tabbarHeight = tabbar.bounds.size.height
            chatTableView.contentInset.bottom = tabbarHeight + 40
            chatTableView.scrollIndicatorInsets = chatTableView.contentInset
        }
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 400
        
        loadDiscussion()
        // Do any additional setup after loading the view.
    }
    
    private func setUpView() {
        //self.changeTitle(title: "General Room")
        
        messageTextInputView.layer.borderWidth = 1
        messageTextInputView.layer.borderColor = UIColor(red: 206/255 ,green: 206/255, blue: 206/255 ,  alpha: 1 ).CGColor
        messageTextInputView.layer.cornerRadius = 5
        //        self.sendMessageButtonOutlet.isEnabled = false
        
        self.chatTableView.addSubview(refeshControl)
    }
    
    
    func loadDiscussion () {
        print("loadDiscussion")
        
        
        FirebaseAPI.sharedInstance.getDiscussions(eventID) { (discussions) in
            self.discussion.removeAll()
            for discussion in discussions {
                print(discussion)
                self.discussion.append(discussion!)
            }
            self.chatTableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSendMessageButton(sender: AnyObject) {
        
        print("Send msg is clicked")
        if let discussion = getMessageInfo() {
            FirebaseAPI.sharedInstance.createDiscussion(eventID, discussion: discussion)
        }
    }
    
    @IBAction func onAttachFileButton(sender: UIButton) {
        print("onAttachFileButton is clicked")
    }
    
    func getMessageInfo() -> Discussion? {
        if let message = messageTextInputView.text {
            let newMessageData: [String:AnyObject] = ["discussion_id": "1", "content_type": ContentType.Text.rawValue,"content_msg": message, "sender_id": currentuserID, "sender_name": "nhung", "sender_photo": "", "time": NSDate().timeIntervalSince1970]
            return Discussion(discussion_id: "1", discussionInfo: newMessageData)
        }
        return nil
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
        print(discussion.count)
        return discussion.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Lấy message ở row index
        let message = discussion[indexPath.row]
        
        // Xác định cell id là của cell cho sender hay reciever
        var cellId = (message.sender_id == currentuserID) ? "cellSender" : "cellReceiver"
        
        // Nếu message là hình thì cell id thêm Photo
        //        if message.type == .Photo  {
        //            cellId += "Photo"
        //        }
        //
        
        let cell = chatTableView.dequeueReusableCellWithIdentifier(cellId) as! ChatTableViewCell
        cell.discussion = message
        //        cell.delegate = self
        
        // Thiết lập màu cho bong bóng chat
        if (message.sender_id == currentuserID) {
            cell.messageBubbleView.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255 , alpha: 1)
        } else {
            cell.messageBubbleView.backgroundColor = UIColor(red: 242/255, green: 120/255, blue: 5/255 , alpha: 1)
        }
        
        /*
         // Hiển thị avatar
         cell.avtImageView.image = avtPlaceHolderImg
         
         // Lấy url user từ userAvtDict đã cache sẵn
         if let avtURL = self.userAvtDict[message.sender] {
         
         // Nếu avt đã được download vào cache, lấy hình ra xài luôn
         if let avtDownloaded = cacheImages.object(forKey: avtURL) as? UIImage {
         cell.avtImageView.image = avtDownloaded
         } else {
         
         let photoDownloader = MessageDownloadPhotoOperation(key: message.messageId, photoURL: avtURL, photoPosition: .avatar, delegate: self)
         self.startDownloadPhoto(downloader: photoDownloader)
         }
         }
         */
        // Nếu message là hình ảnh
        if message.content_type == ContentType.Photo.rawValue {
            /*
             let photoChatCell = cell as! PhotoChatCell
             
             photoChatCell.delegatePhotoChatCell = self
             
             let urlImage = message.content
             
             // Scale size
             let newh = CGFloat(200 * message.imgHeight / message.imgWidth)
             
             photoChatCell.photoHeightConstraint.constant    = newh
             photoChatCell.photoWidthConstraint.constant     = 200
             
             // Check photo đã được download và đưa vào cache chưa,
             // nếu đã có thể lấy ra gán vào image view
             photoChatCell.messgePhotoImgView.image = nil
             
             if let downloadedPhoto = cacheImages.object(forKey: urlImage) as? UIImage {
             
             photoChatCell.messgePhotoImgView.image = downloadedPhoto
             
             } else {
             // Ngược lại nếu table view đang đứng yên (không scroll) thì bắt đầu download hình
             //imageViewSendFromCurrentUser.image = #imageLiteral(resourceName: "default_msg")
             
             if !tableView.isDecelerating {
             
             let photoDownloader = MessageDownloadPhotoOperation(key: message.messageId, photoURL: urlImage, photoPosition: .message, delegate: self)
             self.startDownloadPhoto(downloader: photoDownloader)
             }
             }
             */
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

//
//  EventHeaderTableViewCell.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/12/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import Haneke

class EventHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var goingLabel: UILabel!
    @IBOutlet weak var hostNameButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    weak var delegate: ActionTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(event: Event, image: UIImage) {
        self.selectionStyle = .None
        titleLabel.text = event.name
        
        tagLabel.text = event.tags?.map { "#" + $0 }.joinWithSeparator(", ")
        goingLabel.text = "\(event.joinAmount)"
        hostNameButton.setTitle(event.user?.displayName, forState: .Normal)
        avatarButton.hnk_setImageFromURL(NSURL(string:(event.user?.photoURL)!)!)
        thumbnailImageView.image = image
    }
    
//    func configureCell(event: Event) {
//        self.selectionStyle = .None
//        titleLabel.text = event.name
//        tagLabel.text = event.tags.map { "#" + $0}.joinWithSeparator(", ")
//        goingLabel.text = "\(event.joinAmount)"
//        hostNameButton.setTitle(event.user?.displayName, forState: .Normal)
//        avatarButton.hnk_setImageFromURL(NSURL(string:(event.user?.photoURL)!)!)
////        thumbnailImageView.hnk_setImageFromURL(NSURL(string: event.thumbnailURL!)!)
//        if let urlString = event.thumbnailURL, url = NSURL(string: urlString) {
//             thumbnailImageView.image = UIImage(data: NSData(contentsOfURL: url)!)?.scaleImage(thumbnailImageView.bounds.size)
//        }
//       
//        
////        avatarButton.hnk_setImageFromURL(NSURL(string: event.user.))(UIImage(named: "")?.createRadius(avatarButton.bounds.size, radius: avatarButton.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight]), forState: .Normal)
//        
//    }
    
    func configureCell(event: Event) {
        //        thumbnailImageView.hnk_setImageFromURL(NSURL(string: event.thumbnailURL!)!)
        if let urlString = event.thumbnailURL, url = NSURL(string: urlString) {
//            if let image = UIImage(data: NSData(contentsOfURL: url)!) {
//                configureCell(event, image: image.scaleImage(thumbnailImageView.bounds.size))
//            } else {
//                configureCell(event, image: UIImage(named: "main_event")!)
//            }
            thumbnailImageView.hnk_setImageFromURL(url)

            self.selectionStyle = .None
            titleLabel.text = event.name
            tagLabel.text = event.tags?.map { "#" + $0 }.joinWithSeparator(", ")
            goingLabel.text = "\(event.joinAmount)"
            hostNameButton.setTitle(event.user?.displayName, forState: .Normal)
            avatarButton.hnk_setImageFromURL(NSURL(string:(event.user?.photoURL)!)!)
            print(urlString)
            
//            let imageView = UIImageView()
//                imageView.af_setImageWithURL(url)
//                configureCell(event, image: imageView.image!.scaleImage(thumbnailImageView.bounds.size))
        }
        
        //        avatarButton.hnk_setImageFromURL(NSURL(string: event.user.))(UIImage(named: "")?.createRadius(avatarButton.bounds.size, radius: avatarButton.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight]), forState: .Normal)
        
    }
    

    @IBAction func profileButtonDidTouch(sender: UIButton) {
        delegate.actionTableViewCell!(self, didTouchButton: sender)
    }
}

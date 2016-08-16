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
    
    func configureCell(event: Event) {
        avatarButton.hnk_setImageFromURL(NSURL(string:(event.user?.photoURL)!)!)
        thumbnailImageView.hnk_setImageFromURL(NSURL(string: event.thumbnailURL!)!)
        titleLabel.text = event.name
        tagLabel.text = event.tags?.joinWithSeparator(", ")
        goingLabel.text = "\(event.joinAmount)"
        hostNameButton.setTitle(event.user?.displayName, forState: .Normal)
        print(event.thumbnailURL)

        
        
//        avatarButton.hnk_setImageFromURL(NSURL(string: event.user.))(UIImage(named: "")?.createRadius(avatarButton.bounds.size, radius: avatarButton.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight]), forState: .Normal)
        
    }
    

    @IBAction func profileButtonDidTouch(sender: UIButton) {
        delegate.actionTableViewCell!(self, didTouchButton: sender)
    }
}

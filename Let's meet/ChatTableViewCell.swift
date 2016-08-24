//
//  ChatTableViewCell.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/17/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var messageBubbleView: UIView!
    
    var discussion: Discussion!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

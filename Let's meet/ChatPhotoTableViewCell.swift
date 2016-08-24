//
//  ChatPhotoTableViewCell.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/17/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class ChatPhotoTableViewCell: ChatTableViewCell {
    
    @IBOutlet weak var messagePhotoImgView: UIImageView!
    
    @IBOutlet weak var photoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None

        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

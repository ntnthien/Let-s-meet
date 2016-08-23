//
//  ChatTextTableViewCell.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/17/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class ChatTextTableViewCell: ChatTableViewCell {

    @IBOutlet weak var contentMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentMessageLabel.layer.cornerRadius = 12.0
        contentMessageLabel.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  EventActionTableViewCell.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/15/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

@objc protocol ActionTableViewCellDelegate {
    optional func actionTableViewCell(actionTableViewCell: UITableViewCell, didTouchButton button: UIButton)
}

class EventActionTableViewCell: UITableViewCell {
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var wishButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    weak var delegate: ActionTableViewCellDelegate!
    
    @IBOutlet weak var streamButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func buttonDidTouched(sender: UIButton) {
        delegate.actionTableViewCell!(self, didTouchButton: sender)
    }
    
}

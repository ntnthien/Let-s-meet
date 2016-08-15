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
//        avatarImageView.image = 
    }

    @IBAction func profileButtonDidTouch(sender: UIButton) {
        delegate.actionTableViewCell!(self, didTouchButton: sender)
    }
}

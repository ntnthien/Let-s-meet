//
//  EventDetailTableViewCell.swift
//  Lets meet
//
//  Created by admin on 8/5/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameEventLabel: UILabel!
    @IBOutlet weak var timeEventLabel: UILabel!
    @IBOutlet weak var contentEventLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressButton.layer.cornerRadius = 5
        priceButton.layer.cornerRadius = 5
        priceButton.layer.borderWidth = 2
        priceButton.layer.borderColor = UIColor.blackColor().CGColor
        addressButton.layer.masksToBounds = true
        priceButton.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}

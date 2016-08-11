//
//  CreateEventTableViewCell.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class CreateEventTableViewCell: UITableViewCell {

    @IBOutlet weak var panelImage: UIImageView!
    
    @IBOutlet weak var titleTextfield: UITextField!
    
    @IBOutlet weak var timeTextfield: UITextField!
    
    @IBOutlet weak var availableMeetTextfield: UITextField!
    
    @IBOutlet weak var locationTextfield: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        editButton.tintColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onEditButton(sender: UIButton) {
        print("Edit button is clicked")
    }
}

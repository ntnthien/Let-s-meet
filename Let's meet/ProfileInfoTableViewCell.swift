//
//  ProfileInfoTableViewCell.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var user: User? {
        didSet {
            if let first_name = user?.first_name, last_name = user?.last_name {
                fullNameLabel.text = "\(first_name) \(last_name)"
            }
            if user?.profileUrl != nil {
                let url = user?.profileUrl
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!)
                    //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        self.profileImageView.image = UIImage(data: data!)?.createRadius(self.profileImageView.bounds.size, radius: self.profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
                    })
                }
            } else {
                profileImageView.image = UIImage(named: "user_profile")?.createRadius(profileImageView.bounds.size, radius: profileImageView.bounds.height/2, byRoundingCorners: [.TopLeft, .TopRight, .BottomLeft,.BottomRight])
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

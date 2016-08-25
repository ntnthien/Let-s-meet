//
//  FilterSwitchCell.swift
//  Lets meet
//
//  Created by Nguyễn Thành Thực on 8/20/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit


protocol FilterSwitchCellDelegate {
    func filterSwitchCell(filterSwitchCell: FilterSwitchCell, isSwitch: Bool)
}

class FilterSwitchCell: UITableViewCell {
    
    var delegate: FilterSwitchCellDelegate?
    
    @IBOutlet weak var titleSwitchCell: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchButton.onTintColor = MAIN_COLOR
        switchButton.enabled = false
//        switchButton.
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchAction(sender: AnyObject) {
        delegate?.filterSwitchCell(self, isSwitch: switchButton.on)
        
    }
}


extension FilterSwitchCell: FilterSectionViewDelegate {
    func filterSectionView(filterSectionView: FilterSectionView, isSwitch: Bool) {
        if isSwitch {
            switchButton.enabled = true
        }
        else {
            switchButton.enabled = false
        }
    }
}

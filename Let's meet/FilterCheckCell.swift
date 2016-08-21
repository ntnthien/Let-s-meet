//
//  TableViewCell.swift
//  Lets meet
//
//  Created by Nguyễn Thành Thực on 8/20/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

protocol FilterCheckCellDelegate {
    func filterCheckCell(filterCheckCell: FilterCheckCell, isChecked: Bool)
}

class FilterCheckCell: UITableViewCell {
    var delegate: FilterCheckCellDelegate?

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleCheckCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkButton.layer.cornerRadius = 6
        checkButton.layer.borderColor = MAIN_COLOR.CGColor
        checkButton.layer.borderWidth = 1.5
        checkButton.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkAction(sender: UIButton) {
        checkButton.selected = !checkButton.selected
        delegate?.filterCheckCell(self, isChecked: checkButton.selected)
    }
}

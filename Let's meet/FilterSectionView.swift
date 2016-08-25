//
//  HeaderFooterView.swift
//  Lets meet
//
//  Created by Nguyễn Thành Thực on 8/20/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

@objc
protocol FilterSectionViewDelegate {
    optional func filterSectionView(filterSectionView: FilterSectionView, isNextAction: Bool, index: Int)
    optional func filterSectionView(filterSectionView: FilterSectionView, isSwitch: Bool)
}

class FilterSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var customLabel: UILabel!
    var delegate: FilterSectionViewDelegate?
    
    var sectionNumber: Int?
    
    override func awakeFromNib() {
        switchButton.onTintColor = MAIN_COLOR
        switchButton.on = false
    }
    
    @IBAction func nextAction(sender: AnyObject) {
        let num = Int(indexLabel.text!)
        delegate?.filterSectionView!(self, isNextAction: true, index: num!)
    }
    
    @IBAction func switchAction(sender: UISwitch) {
        delegate?.filterSectionView!(self, isSwitch: sender.on)
    }
    
    @IBAction func previousAction(sender: AnyObject) {
        let num = Int(indexLabel.text!)
        delegate?.filterSectionView!(self, isNextAction: false, index: num!)
    }
}

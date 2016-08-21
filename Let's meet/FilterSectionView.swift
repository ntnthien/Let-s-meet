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
    optional func filterSectionView(isNextAction: Bool, index: Int)
}

class FilterSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var customLabel: UILabel!
    var delegate: FilterSectionViewDelegate?
    
    var sectionNumber: Int?
    
    @IBAction func nextAction(sender: AnyObject) {
        let num = Int(indexLabel.text!)
        delegate?.filterSectionView!(true, index: num!)
    }
    
    @IBAction func previousAction(sender: AnyObject) {
        let num = Int(indexLabel.text!)
        delegate?.filterSectionView!(false, index: num!)
    }
}

//
//  UIView+Border.swift
//  Add Border to UIView
//
//  Created by Do Nguyen on 6/2/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//
import UIKit

extension UIView {
    func addBorders(size: CGFloat, color: UIColor) {
        self.addBorderTop(size: size, color: color)
        self.addBorderBottom(size: size, color: color)
        self.addBorderLeft(size: size, color: color)
        self.addBorderRight(size: size, color: color)
    }
    
    func addBorderTop(size size: CGFloat, color: UIColor) {
        addBorder(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size size: CGFloat, color: UIColor) {
        addBorder(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size size: CGFloat, color: UIColor) {
        addBorder(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size size: CGFloat, color: UIColor) {
        addBorder(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorder(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}